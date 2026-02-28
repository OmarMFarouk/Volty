import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/src/app_globals.dart';
import '../../models/ai_model.dart';
import '../../services/apis/ai_api.dart';
import '../../services/tflite.dart';
import '../../src/app_string.dart';
import 'states.dart';

class AICubit extends Cubit<AIStates> {
  AICubit() : super(AIInitial());

  static AICubit get(context) => BlocProvider.of(context);

  AiModel? aiModel;

  Future<void> fetchAIInsights() async {
    emit(AILoading());
    try {
      final raw = await AIApi().fetchFeatures();

      if (raw == null || raw['success'] != true) {
        final serverMsg = raw?['message'] as String?;
        emit(
          AIError(
            msgKey: serverMsg == null ? AppString.aiErrorNetwork : null,
            rawMsg: serverMsg,
          ),
        );
        return;
      }

      final tierFeatures = Map<String, dynamic>.from(
        raw['tier_crossing_features'] ?? {},
      );
      final forecastFeatures = Map<String, dynamic>.from(
        raw['forecast_features'] ?? {},
      );
      final anomalyInputs = List<Map<String, dynamic>>.from(
        (raw['anomaly_inputs'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );
      final context = Map<String, dynamic>.from(raw['context'] ?? {});
      final peakDevices = List<Map<String, dynamic>>.from(
        (raw['peak_hour_devices'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      final inference = await VoltyInferenceService.instance.runAll(
        tierFeatures: tierFeatures,
        forecastFeatures: forecastFeatures,
        anomalyInputs: anomalyInputs,
      );

      aiModel = _buildDisplayModel(
        tierFeatures: tierFeatures,
        forecastFeatures: forecastFeatures,
        context: context,
        peakDevices: peakDevices,
        inference: inference,
      );

      AppGlobals.aiModel = aiModel;
      emit(AISuccess(msgKey: AppString.aiSuccessLoad));
    } catch (e) {
      emit(
        AIError(
          msgKey: AppString.aiErrorGeneric,
          errorArgs: {'error': e.toString()},
        ),
      );
    }
  }

  AiModel _buildDisplayModel({
    required Map<String, dynamic> tierFeatures,
    required Map<String, dynamic> forecastFeatures,
    required Map<String, dynamic> context,
    required List<Map<String, dynamic>> peakDevices,
    required AIInferenceResult inference,
  }) {
    final tf = tierFeatures;
    final ctx = context;

    // ── Tier crossing ──────────────────────────────────────────────────────
    final willCross = inference.tierCrossing.willCross;
    final confidence = inference.tierCrossing.confidence;
    final projKwh = (tf['projected_month_end_kwh'] as num? ?? 0).toDouble();
    final tierMax = (tf['tier_max_kwh'] as num? ?? 650).toDouble();
    final distToNext = (tf['distance_to_next_tier'] as num? ?? 0).toDouble();
    final projBill = inference.forecastedBillEgp;
    final curBill = (ctx['current_bill_egp'] as num? ?? 0).toDouble();
    final potentialSavings = willCross
        ? max(0.0, projBill - curBill) * 0.6
        : 0.0;

    // ── Anomalies ──────────────────────────────────────────────────────────
    final anomalies = inference.anomalies.map((a) {
      // Map severity label coming from TFLite service to the canonical enum.
      // TFLite service returns English labels: "high", "medium", "low".
      final sev = _parseSeverity(a.severityLabel);

      // Map the anomaly's internal type to an AppString title/description key.
      // If the server returns a known type, use its dedicated key pair;
      // otherwise fall back to the generic anomaly keys.
      final titleKey = _anomalyTitleKey(a.title);
      final descKey = _anomalyDescKey(a.title);

      return AnomalyItem(
        titleKey: titleKey,
        descriptionKey: descKey,
        severity: sev,
        deviceName: a.deviceName,
        anomalyScore: a.probability,
        detectedAt: a.date,
      );
    }).toList();

    // ── Smart schedule ─────────────────────────────────────────────────────
    // Device names come from the user's own data — keep as-is.
    // 'reason' is gone; the widget always uses AppString.scheduleReasonPeak.tr()
    final schedule = peakDevices
        .map(
          (d) => SmartScheduleItem(
            deviceName: d['device_name'] as String? ?? '',
            deviceType: d['device_type'] as String? ?? '',
            recommendedTimeRange: d['recommended_time_range'] as String? ?? '',
            savingsEgp: (d['savings_egp'] as num? ?? 0).toDouble(),
          ),
        )
        .toList();

    // ── Cost forecast ──────────────────────────────────────────────────────
    final dailyRate = (forecastFeatures['daily_kwh_rate'] as num? ?? 0)
        .toDouble();
    final curMonth = (forecastFeatures['month'] as num? ?? 1).toInt();
    const sf = <int, double>{
      1: 0.85,
      2: 0.80,
      3: 0.90,
      4: 1.00,
      5: 1.15,
      6: 1.30,
      7: 1.40,
      8: 1.35,
      9: 1.20,
      10: 1.05,
      11: 0.90,
      12: 0.85,
    };
    final forecast = List.generate(5, (i) {
      final m = ((curMonth - 1 + i) % 12) + 1;
      final factor = sf[m] ?? 1.0;
      final kwh = dailyRate * 30 * factor;
      final cost = i == 0 ? projBill : _calculateBill(kwh);
      return MonthForecast(
        monthNumber: m, // widget calls AppString.monthKey(m).tr()
        cost: cost,
        consumptionKwh: kwh,
        changePercent: factor - 1,
      );
    });

    // ── Quick insights ─────────────────────────────────────────────────────
    final prevKwh = (ctx['prev_month_kwh'] as num? ?? 0).toDouble();
    final curKwh = (ctx['current_kwh'] as num? ?? 0).toDouble();
    final dayOfMonth = (tf['day_of_month'] as num? ?? 1).toInt();
    final curDailyRate = dayOfMonth > 0 ? curKwh / dayOfMonth : 0.0;
    final prevDailyRate = prevKwh / 30.0;
    final trendPct = prevDailyRate > 0
        ? (curDailyRate - prevDailyRate) / prevDailyRate * 100
        : 0.0;
    final topDevice = ctx['top_device'] as Map<String, dynamic>?;
    final carbonKg = (ctx['carbon_kg'] as num? ?? 0).toDouble();

    final quickInsights = [
      QuickInsight(
        type: QuickInsightType.trend,
        numericValue: trendPct.abs(),
        isPositive: trendPct >= 0,
      ),
      QuickInsight(
        type: QuickInsightType.peakHours,
        // 22–06 is a business rule, not a translatable string.
        // Widget formats it using a fixed time pattern.
      ),
      QuickInsight(
        type: QuickInsightType.topDevice,
        deviceName: topDevice?['name'] as String?,
      ),
      QuickInsight(type: QuickInsightType.carbon, numericValue: carbonKg),
    ];

    // ── Behavior profile ───────────────────────────────────────────────────
    final hourlyDist = List<int>.from(
      ctx['hourly_distribution'] ?? List.filled(24, 0),
    );
    final morning = _sumRange(hourlyDist, 6, 12);
    final noon = _sumRange(hourlyDist, 12, 17);
    final evening = _sumRange(hourlyDist, 17, 22);
    final night = _sumRange(hourlyDist, 22, 24) + _sumRange(hourlyDist, 0, 6);
    final maxVal = [morning, noon, evening, night].reduce(max);

    final UsagePattern pattern;
    if (maxVal == morning)
      pattern = UsagePattern.morning;
    else if (maxVal == noon)
      pattern = UsagePattern.afternoon;
    else if (maxVal == evening)
      pattern = UsagePattern.evening;
    else
      pattern = UsagePattern.night;

    final total = hourlyDist.fold(0, (a, b) => a + b);
    final peakHours = _sumRange(hourlyDist, 12, 20);
    final effScore = total > 0 ? (1 - peakHours / total) * 100 : 50.0;

    // Map raw peak day from server to an AppString day key.
    final rawPeakDay = ctx['peak_day']?.toString() ?? '';
    final peakDayKey = _dayKey(rawPeakDay);

    final behavior = BehaviorProfile(
      usagePattern: pattern,
      peakDayKey: peakDayKey,
      efficiencyScore: effScore,
      homeRating: _homeRating(effScore), // "A+", "A", etc. — universal
    );

    // ── Recommendations ────────────────────────────────────────────────────
    final recs = <RecommendationItem>[];
    if (willCross) {
      final overage = max(0.0, projKwh - tierMax);
      final savingsVal = (overage * 1.55).toStringAsFixed(0);
      recs.add(
        RecommendationItem(
          titleKey: AppString.recAcReduceTitle,
          titleArgs: {'n': overage.toStringAsFixed(0)},
          savingsKey: AppString.recSavingsEgp,
          savingsArgs: {'n': savingsVal},
          category: 'tier_protection',
          impactStars: 5,
        ),
      );
    }
    recs.addAll([
      RecommendationItem(
        titleKey: AppString.recAcTempTitle,
        savingsKey: AppString.recAcTempSavings,
        category: 'ac',
        impactStars: 4,
      ),
      RecommendationItem(
        titleKey: AppString.recHeaterTitle,
        savingsKey: AppString.recHeaterSavings,
        category: 'schedule',
        impactStars: 3,
      ),
      RecommendationItem(
        titleKey: AppString.recLightingTitle,
        savingsKey: AppString.recLightingSavings,
        category: 'lighting',
        impactStars: 2,
      ),
      RecommendationItem(
        titleKey: AppString.recStandbyTitle,
        savingsKey: AppString.recStandbySavings,
        category: 'standby',
        impactStars: 2,
      ),
    ]);

    return AiModel(
      tierCrossing: TierCrossingPrediction(
        willCross: willCross,
        confidence: confidence,
        currentTierIdx: (tf['current_tier_idx'] as num? ?? 4).toInt(),
        tierMaxKwh: tierMax,
        distanceToNextTier: distToNext,
        projectedMonthEndKwh: projKwh,
        projectedBillEgp: projBill,
        potentialSavings: potentialSavings,
        billIncreaseIfCross: max(0, projBill - curBill),
        daysRemaining: (tf['days_remaining'] as num? ?? 0).toInt(),
      ),
      smartSchedule: schedule,
      anomalies: anomalies,
      costForecast: forecast,
      recommendations: recs,
      quickInsights: quickInsights,
      behaviorProfile: behavior,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  int _sumRange(List<int> list, int start, int end) =>
      list.sublist(start, end.clamp(0, list.length)).fold(0, (a, b) => a + b);

  AnomalySeverity _parseSeverity(String label) {
    switch (label.toLowerCase()) {
      case 'high':
        return AnomalySeverity.high;
      case 'medium':
        return AnomalySeverity.medium;
      default:
        return AnomalySeverity.low;
    }
  }

  /// Maps a raw anomaly title from the inference service to an AppString key.
  /// Add more entries as the TFLite service defines more anomaly types.
  String _anomalyTitleKey(String rawTitle) {
    final t = rawTitle.toLowerCase();
    if (t.contains('night') || t.contains('ليلي'))
      return AppString.anomalyNightTitle;
    if (t.contains('spike') || t.contains('ارتفاع'))
      return AppString.anomalySpikeTitle;
    if (t.contains('idle') || t.contains('خامل'))
      return AppString.anomalyIdleTitle;
    return AppString.anomalyGenericTitle;
  }

  String _anomalyDescKey(String rawTitle) {
    final t = rawTitle.toLowerCase();
    if (t.contains('night') || t.contains('ليلي'))
      return AppString.anomalyNightDesc;
    if (t.contains('spike') || t.contains('ارتفاع'))
      return AppString.anomalySpikeDesc;
    if (t.contains('idle') || t.contains('خامل'))
      return AppString.anomalyIdleDesc;
    return AppString.anomalyGenericDesc;
  }

  /// Maps a server-returned peak day string (could be English or Arabic)
  /// to the canonical AppString key for that day.
  String _dayKey(String raw) {
    final d = raw.toLowerCase().trim();
    if (d == 'saturday' || d == 'السبت') return AppString.saturday;
    if (d == 'sunday' || d == 'الأحد') return AppString.sunday;
    if (d == 'monday' || d == 'الاثنين') return AppString.monday;
    if (d == 'tuesday' || d == 'الثلاثاء') return AppString.tuesday;
    if (d == 'wednesday' || d == 'الأربعاء') return AppString.wednesday;
    if (d == 'thursday' || d == 'الخميس') return AppString.thursday;
    if (d == 'friday' || d == 'الجمعة') return AppString.friday;
    return AppString.friday; // safe fallback
  }

  String _homeRating(double score) {
    if (score >= 80) return 'A+';
    if (score >= 70) return 'A';
    if (score >= 60) return 'B+';
    if (score >= 50) return 'B';
    return 'C';
  }

  static double _calculateBill(double kwh) {
    const tiers = [
      [50.0, 0.68],
      [100.0, 0.78],
      [200.0, 0.95],
      [350.0, 1.55],
      [650.0, 1.95],
      [1000.0, 2.10],
      [999999.0, 2.23],
    ];
    double rem = kwh, total = 0, prev = 0;
    for (final t in tiers) {
      if (rem <= 0) break;
      final s = min(rem, (t[0]) - prev);
      total += s * (t[1]);
      rem -= s;
      prev = t[0];
    }
    return total;
  }

  void refreshState() => emit(AIInitial());
}

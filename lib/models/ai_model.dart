// ══════════════════════════════════════════════════════════════════════════════
// ai_model.dart  –  Locale-neutral data model
//
// RULE: No display strings stored here. The cubit populates raw numbers and
// AppString KEY constants. Widget layer resolves .tr() and formats values.
// ══════════════════════════════════════════════════════════════════════════════

class AiModel {
  final TierCrossingPrediction? tierCrossing;
  final List<SmartScheduleItem> smartSchedule;
  final List<AnomalyItem> anomalies;
  final List<MonthForecast> costForecast;
  final List<RecommendationItem> recommendations;
  final List<QuickInsight> quickInsights;
  final BehaviorProfile? behaviorProfile;

  const AiModel({
    this.tierCrossing,
    this.smartSchedule = const [],
    this.anomalies = const [],
    this.costForecast = const [],
    this.recommendations = const [],
    this.quickInsights = const [],
    this.behaviorProfile,
  });
}

// ─── Tier Crossing ────────────────────────────────────────────────────────────

class TierCrossingPrediction {
  final bool willCross;
  final double confidence; // 0.0–1.0
  final int currentTierIdx;
  final double tierMaxKwh;
  final double distanceToNextTier;
  final double projectedMonthEndKwh;
  final double projectedBillEgp;
  final double potentialSavings;
  final double billIncreaseIfCross;
  final int daysRemaining;

  const TierCrossingPrediction({
    required this.willCross,
    required this.confidence,
    required this.currentTierIdx,
    required this.tierMaxKwh,
    required this.distanceToNextTier,
    required this.projectedMonthEndKwh,
    required this.projectedBillEgp,
    required this.potentialSavings,
    required this.billIncreaseIfCross,
    required this.daysRemaining,
  });
}

// ─── Smart Schedule ───────────────────────────────────────────────────────────

class SmartScheduleItem {
  final String deviceName; // from server — already user's custom name
  final String deviceType; // raw type key e.g. "ac", "water_heater"
  final String recommendedTimeRange; // "22:00 – 06:00" — time, not translated
  final double savingsEgp; // raw number
  // No 'reason' string — widget uses AppString.scheduleReasonPeak.tr()

  const SmartScheduleItem({
    required this.deviceName,
    required this.deviceType,
    required this.recommendedTimeRange,
    required this.savingsEgp,
  });
}

// ─── Anomaly ──────────────────────────────────────────────────────────────────

/// Severity is stored as a canonical key so the widget can call
/// AppString.severityHigh/Medium/Low.tr() without string-matching Arabic.
enum AnomalySeverity { high, medium, low }

class AnomalyItem {
  final String titleKey; // AppString key  e.g. AppString.anomalyNightSpike
  final String
  descriptionKey; // AppString key  e.g. AppString.anomalyNightSpikeDesc
  final AnomalySeverity severity;
  final String deviceName; // user's device name — not translated
  final double anomalyScore; // 0.0–1.0
  final String detectedAt; // ISO date string "2026-02-14" — widget formats

  const AnomalyItem({
    required this.titleKey,
    required this.descriptionKey,
    required this.severity,
    required this.deviceName,
    required this.anomalyScore,
    required this.detectedAt,
  });
}

// ─── Cost Forecast ────────────────────────────────────────────────────────────

class MonthForecast {
  final int monthNumber; // 1–12 — widget resolves AppString.monthKey(n).tr()
  final double cost; // raw EGP
  final double consumptionKwh;
  final double changePercent; // e.g. 0.15 = +15%

  const MonthForecast({
    required this.monthNumber,
    required this.cost,
    required this.consumptionKwh,
    required this.changePercent,
  });
}

// ─── Quick Insights ───────────────────────────────────────────────────────────

/// The widget resolves display text from typed fields — no hardcoded strings.
class QuickInsight {
  final QuickInsightType type;
  final double numericValue; // trend %, carbon kg, etc.
  final bool isPositive; // trend: true=up, false=down
  final String? deviceName; // top_device — already user's name from server

  const QuickInsight({
    required this.type,
    this.numericValue = 0,
    this.isPositive = true,
    this.deviceName,
  });
}

enum QuickInsightType { trend, peakHours, topDevice, carbon }

// ─── Behavior Profile ─────────────────────────────────────────────────────────

enum UsagePattern { morning, afternoon, evening, night }

class BehaviorProfile {
  final UsagePattern usagePattern; // enum — widget calls .labelKey.tr()
  final String peakDayKey; // AppString day key e.g. AppString.friday
  final double efficiencyScore; // 0–100
  final String homeRating; // "A+", "A", "B+", "B", "C" — universal

  const BehaviorProfile({
    required this.usagePattern,
    required this.peakDayKey,
    required this.efficiencyScore,
    required this.homeRating,
  });
}

// ─── Recommendation ───────────────────────────────────────────────────────────

/// Recommendation titles/savings are stored as keys + raw numeric args.
/// Widget calls titleKey.tr(namedArgs: titleArgs).
class RecommendationItem {
  final String titleKey; // AppString key
  final Map<String, String> titleArgs; // named args for .tr()
  final String savingsKey; // AppString key e.g. AppString.recSavingsEgp
  final Map<String, String> savingsArgs;
  final String category; // "ac", "schedule", "tier_protection", etc.
  final int impactStars; // 1–5

  const RecommendationItem({
    required this.titleKey,
    this.titleArgs = const {},
    required this.savingsKey,
    this.savingsArgs = const {},
    required this.category,
    required this.impactStars,
  });
}

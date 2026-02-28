import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// On-device TFLite inference for all 3 Volty models.
///
/// IMPORTANT path note:
///   tflite_flutter's Interpreter.fromAsset() strips the leading
///   'assets/' automatically — pass only the sub-path:
///     ✓  'models/volty_tier_model.tflite'
///     ✗  'assets/models/volty_tier_model.tflite'
///
///   rootBundle.loadString() is the opposite — needs the full path:
///     ✓  'assets/models/volty_tier_scaler.json'
///     ✗  'models/volty_tier_scaler.json'
class VoltyInferenceService {
  VoltyInferenceService._();
  static final instance = VoltyInferenceService._();

  // Interpreters — null means that model failed to load
  Interpreter? _tierInterp;
  Interpreter? _anomalyInterp;
  Interpreter? _forecastInterp;

  // Scalers — null means fallback to hardcoded rules
  Map<String, dynamic>? _tierScaler;
  Map<String, dynamic>? _anomalyScaler;
  Map<String, dynamic>? _forecastScaler;

  bool _initialised = false;

  // ── Initialise (call once, e.g. in main() or before first use) ────

  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    await Future.wait([
      _loadModel(
        'assets/models/volty_tier_model.tflite',
        (i) => _tierInterp = i,
      ),
      _loadModel(
        'assets/models/volty_anomaly_model.tflite',
        (i) => _anomalyInterp = i,
      ),
      _loadModel(
        'assets/models/volty_forecast_model.tflite',
        (i) => _forecastInterp = i,
      ),
      _loadScaler(
        'assets/models/volty_tier_scaler.json',
        (s) => _tierScaler = s,
      ),
      _loadScaler(
        'assets/models/volty_anomaly_scaler.json',
        (s) => _anomalyScaler = s,
      ),
      _loadScaler(
        'assets/models/volty_forecast_scaler.json',
        (s) => _forecastScaler = s,
      ),
    ]);

    final tierOk = _tierInterp != null;
    final anomalyOk = _anomalyInterp != null;
    final forecastOk = _forecastInterp != null;

    if (kDebugMode) {
      debugPrint(
        '[Volty] TFLite loaded — tier=$tierOk  anomaly=$anomalyOk  forecast=$forecastOk',
      );
    }
  }

  Future<void> _loadModel(
    String path,
    void Function(Interpreter) onSuccess,
  ) async {
    try {
      final interp = await Interpreter.fromAsset(path);
      onSuccess(interp);
      if (kDebugMode) debugPrint('[Volty] ✅ Model loaded: $path');
    } catch (e) {
      if (kDebugMode)
        debugPrint(
          '[Volty] ❌ Could not load $path: $e — will use rule fallback',
        );
    }
  }

  Future<void> _loadScaler(
    String assetPath,
    void Function(Map<String, dynamic>) onSuccess,
  ) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      onSuccess(jsonDecode(raw) as Map<String, dynamic>);
      if (kDebugMode) debugPrint('[Volty] ✅ Scaler loaded: $assetPath');
    } catch (e) {
      if (kDebugMode) debugPrint('[Volty] ❌ Could not load $assetPath: $e');
    }
  }

  // ── Public entry point ────────────────────────────────────────────

  Future<AIInferenceResult> runAll({
    required Map<String, dynamic> tierFeatures,
    required Map<String, dynamic> forecastFeatures,
    required List<Map<String, dynamic>> anomalyInputs,
  }) async {
    await init();
    return AIInferenceResult(
      tierCrossing: _runTierModel(tierFeatures),
      forecastedBillEgp: _runForecastModel(forecastFeatures),
      anomalies: _runAnomalyModel(anomalyInputs),
    );
  }

  // ── Model 1: Tier Crossing ────────────────────────────────────────

  TierCrossingResult _runTierModel(Map<String, dynamic> f) {
    try {
      if (_tierInterp == null || _tierScaler == null) {
        return _tierFallback(f);
      }

      final prob = _runBinaryModel(
        interpreter: _tierInterp!,
        scaler: _tierScaler!,
        features: f,
      );

      final willCross = prob >= 0.50;
      return TierCrossingResult(
        willCross: willCross,
        probability: prob,
        confidence: willCross ? prob : 1.0 - prob,
      );
    } catch (e) {
      // ignore: avoid_debugPrint
      debugPrint('[Volty] Tier model error: $e');
      return _tierFallback(f);
    }
  }

  TierCrossingResult _tierFallback(Map<String, dynamic> f) {
    final proj = _d(f['projected_month_end_kwh']);
    final tMax = _d(f['tier_max_kwh'], 650);
    final margin = tMax - proj;
    final prob = margin < 0
        ? (0.70 + min(0.28, (-margin / (tMax + 1)) * 0.4))
        : max(0.05, 0.50 - (margin / (tMax + 1)) * 0.45);
    final willCross = prob >= 0.50;
    return TierCrossingResult(
      willCross: willCross,
      probability: prob,
      confidence: willCross ? prob : 1.0 - prob,
    );
  }

  // ── Model 2: Anomaly Scorer ───────────────────────────────────────

  List<AnomalyResult> _runAnomalyModel(List<Map<String, dynamic>> inputs) {
    final results = <AnomalyResult>[];
    if (inputs.isEmpty) return results;

    for (final item in inputs) {
      final af =
          (item['anomaly_features'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          {};

      double prob;
      try {
        if (_anomalyInterp != null && _anomalyScaler != null) {
          prob = _runBinaryModel(
            interpreter: _anomalyInterp!,
            scaler: _anomalyScaler!,
            features: af,
          );
        } else {
          final z = _d(af['z_score']);
          prob = _sigmoid(z - 1.5);
        }
      } catch (_) {
        final z = _d(af['z_score']);
        prob = _sigmoid(z - 1.5);
      }

      if (prob >= 0.45) {
        results.add(
          AnomalyResult(
            deviceId: item['device_id']?.toString() ?? '',
            deviceName: item['device_name']?.toString() ?? '',
            deviceType: item['device_type']?.toString() ?? '',
            date: item['date']?.toString() ?? '',
            probability: prob,
            zScore: _d(af['z_score']),
            isNight: _d(af['is_night']) > 0,
          ),
        );
      }
    }

    results.sort((a, b) => b.probability.compareTo(a.probability));
    return results.take(5).toList();
  }

  // ── Model 3: Cost Forecaster ──────────────────────────────────────

  double _runForecastModel(Map<String, dynamic> f) {
    try {
      if (_forecastInterp == null || _forecastScaler == null) {
        return _forecastFallback(f);
      }

      final cols = List<String>.from(_forecastScaler!['feature_columns']);
      final mean = List<double>.from(_forecastScaler!['mean']);
      final std = List<double>.from(_forecastScaler!['std']);
      final tgtMean = (_forecastScaler!['target_mean'] as num).toDouble();
      final tgtStd = (_forecastScaler!['target_std'] as num).toDouble();

      final raw = cols.map((c) => _d(f[c])).toList();
      final norm = List<double>.generate(
        raw.length,
        (i) => (raw[i] - mean[i]) / (std[i] + 1e-8),
      );

      final input = [norm];
      final output = [List<double>.filled(1, 0.0)];
      _forecastInterp!.run(input, output);

      return max(0.0, output[0][0] * tgtStd + tgtMean);
    } catch (e) {
      // ignore: avoid_debugPrint
      debugPrint('[Volty] Forecast model error: $e');
      return _forecastFallback(f);
    }
  }

  double _forecastFallback(Map<String, dynamic> f) {
    final daily = _d(f['daily_kwh_rate']);
    final sf = _d(f['seasonal_factor'], 1);
    return _bill(daily * 30 * sf);
  }

  // ── Shared: run a binary model (sigmoid output) ───────────────────

  double _runBinaryModel({
    required Interpreter interpreter,
    required Map<String, dynamic> scaler,
    required Map<String, dynamic> features,
  }) {
    final cols = List<String>.from(scaler['feature_columns']);
    final mean = List<double>.from(scaler['mean']);
    final std = List<double>.from(scaler['std']);

    final raw = cols.map((c) => _d(features[c])).toList();
    final norm = List<double>.generate(
      raw.length,
      (i) => (raw[i] - mean[i]) / (std[i] + 1e-8),
    );

    // tflite_flutter expects List<List<double>> for a [1, N] tensor
    final input = [norm];
    final output = [List<double>.filled(1, 0.0)];
    interpreter.run(input, output);

    return output[0][0].clamp(0.0, 1.0);
  }

  // ── Utilities ─────────────────────────────────────────────────────

  static double _d(dynamic v, [double def = 0.0]) =>
      v == null ? def : (v as num).toDouble();

  static double _sigmoid(double x) => 1.0 / (1.0 + exp(-x));

  static double _bill(double kwh) {
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
      final s = min(rem, t[0] - prev);
      total += s * t[1];
      rem -= s;
      prev = t[0];
    }
    return total;
  }

  void dispose() {
    _tierInterp?.close();
    _anomalyInterp?.close();
    _forecastInterp?.close();
    _initialised = false;
  }
}

// ── Result classes ─────────────────────────────────────────────────

class AIInferenceResult {
  final TierCrossingResult tierCrossing;
  final double forecastedBillEgp;
  final List<AnomalyResult> anomalies;
  const AIInferenceResult({
    required this.tierCrossing,
    required this.forecastedBillEgp,
    required this.anomalies,
  });
}

class TierCrossingResult {
  final bool willCross;
  final double probability;
  final double confidence;
  const TierCrossingResult({
    required this.willCross,
    required this.probability,
    required this.confidence,
  });
}

class AnomalyResult {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String date;
  final double probability;
  final double zScore;
  final bool isNight;

  const AnomalyResult({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.date,
    required this.probability,
    required this.zScore,
    required this.isNight,
  });

  String get severityLabel {
    if (probability >= 0.80) return 'عالي';
    if (probability >= 0.60) return 'متوسط';
    return 'منخفض';
  }

  String get title => isNight
      ? 'تشغيل ليلي غير معتاد'
      : zScore > 3
      ? 'ارتفاع حاد في الاستهلاك'
      : 'ارتفاع غير عادي';

  String get description {
    if (isNight) return '$deviceName يعمل في ساعات الليل بتاريخ $date';
    final pct = ((probability - 0.5) * 200).round().clamp(20, 500);
    return 'تجاوز $deviceName حوالي $pct% من معدله الطبيعي بتاريخ $date';
  }
}

import 'package:volty/src/app_localization.dart';

class AnalyticsModel {
  bool? success;
  String? message;
  String? period;
  String? selectedDate;
  ConsumptionData? consumption;
  PricingData? pricing;
  List<BreakdownItem>? breakdown;
  List<DeviceRanking>? deviceRankings;
  List<PeakUsage>? peakUsage;

  AnalyticsModel({
    this.success,
    this.message,
    this.period,
    this.selectedDate,
    this.consumption,
    this.pricing,
    this.breakdown,
    this.deviceRankings,
    this.peakUsage,
  });

  AnalyticsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    period = json['period'];
    selectedDate = json['selected_date'];
    consumption = json['consumption'] != null
        ? ConsumptionData.fromJson(json['consumption'])
        : null;
    pricing = json['pricing'] != null
        ? PricingData.fromJson(json['pricing'])
        : null;
    breakdown = <BreakdownItem>[];
    if (json['breakdown'] != null) {
      json['breakdown'].forEach((v) {
        breakdown!.add(BreakdownItem.fromJson(v, period ?? 'month'));
      });
    }
    deviceRankings = <DeviceRanking>[];
    if (json['device_rankings'] != null) {
      json['device_rankings'].forEach((v) {
        deviceRankings!.add(DeviceRanking.fromJson(v));
      });
    }
    peakUsage = <PeakUsage>[];
    if (json['peak_usage'] != null) {
      json['peak_usage'].forEach((v) {
        peakUsage!.add(PeakUsage.fromJson(v));
      });
    }
  }
}

class ConsumptionData {
  double? currentPeriodTotal;
  double? previousPeriodTotal;
  ComparisonData? comparison;

  ConsumptionData({
    this.currentPeriodTotal,
    this.previousPeriodTotal,
    this.comparison,
  });

  ConsumptionData.fromJson(Map<String, dynamic> json) {
    currentPeriodTotal =
        double.tryParse(json['current_period_total'].toString()) ?? 0.0;
    previousPeriodTotal =
        double.tryParse(json['previous_period_total'].toString()) ?? 0.0;
    comparison = json['comparison'] != null
        ? ComparisonData.fromJson(json['comparison'])
        : null;
  }
}

class ComparisonData {
  double? difference;
  double? percentage;
  bool? isIncrease;
  String? periodText;

  ComparisonData({
    this.difference,
    this.percentage,
    this.isIncrease,
    this.periodText,
  });

  ComparisonData.fromJson(Map<String, dynamic> json) {
    difference = double.tryParse(json['difference'].toString()) ?? 0.0;
    percentage = double.tryParse(json['percentage'].toString()) ?? 0.0;
    isIncrease = json['is_increase'] ?? false;
    periodText = json['period_text'].toString();
  }
}

class PricingData {
  List<PricingTier>? tiers;
  double? currentTotal;
  double? previousTotal;

  PricingData({this.tiers, this.currentTotal, this.previousTotal});

  PricingData.fromJson(Map<String, dynamic> json) {
    tiers = <PricingTier>[];
    if (json['tiers'] != null) {
      json['tiers'].forEach((v) {
        tiers!.add(PricingTier.fromJson(v));
      });
    }
    currentTotal = double.tryParse(json['current_total'].toString()) ?? 0.0;
    previousTotal = double.tryParse(json['previous_total'].toString()) ?? 0.0;
  }
}

class PricingTier {
  String? tierName;
  double? consumption;
  double? rate;
  double? cost;

  PricingTier({this.tierName, this.consumption, this.rate, this.cost});

  PricingTier.fromJson(Map<String, dynamic> json) {
    tierName = json['tier_name'];
    consumption = double.tryParse(json['consumption'].toString()) ?? 0.0;
    rate = double.tryParse(json['rate'].toString()) ?? 0.0;
    cost = double.tryParse(json['cost'].toString()) ?? 0.0;
  }
}

class BreakdownItem {
  String? label;
  double? consumption;
  double? normalizedValue;

  // For week view
  String? day;
  String? dayFull;
  String? date;
  bool? isToday;

  // For month view
  int? dayNum;

  // For year view
  String? month;
  int? monthNum;

  BreakdownItem({
    this.label,
    this.consumption,
    this.normalizedValue,
    this.day,
    this.dayFull,
    this.date,
    this.isToday,
    this.dayNum,
    this.month,
    this.monthNum,
  });

  BreakdownItem.fromJson(Map<String, dynamic> json, String period) {
    consumption = double.tryParse(json['consumption'].toString()) ?? 0.0;
    normalizedValue =
        double.tryParse(json['normalized_value'].toString()) ?? 0.0;

    switch (period) {
      case 'day':
        label = json['label'];
        break;
      case 'week':
        day = json['day'];
        dayFull = json['day_full'];
        date = json['date'];
        isToday = json['is_today'] ?? false;
        label = day;
        break;
      case 'month':
        dayNum = json['day'];
        date = json['date'];
        label = dayNum.toString();
        break;
      case 'year':
        month = json['month'];
        monthNum = json['month_num'];
        label = month?.substring(0, 3) ?? '';
        break;
    }
  }
}

class DeviceRanking {
  int? rank;
  String? deviceName;
  String? deviceType;
  double? consumption;
  double? percentage;

  DeviceRanking({
    this.rank,
    this.deviceName,
    this.deviceType,
    this.consumption,
    this.percentage,
  });

  DeviceRanking.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    deviceName = json['device_name'];
    deviceType = json['device_type'];
    consumption = double.tryParse(json['consumption'].toString()) ?? 0.0;
    percentage = double.tryParse(json['percentage'].toString()) ?? 0.0;
  }
}

class PeakUsage {
  String? timeRange;
  String? level;
  double? avgConsumption;
  double? peakConsumption;

  PeakUsage({
    this.timeRange,
    this.level,
    this.avgConsumption,
    this.peakConsumption,
  });

  PeakUsage.fromJson(Map<String, dynamic> json) {
    timeRange = json['time_range'];
    level = json['level'];
    avgConsumption = double.tryParse(json['avg_consumption'].toString()) ?? 0.0;
    peakConsumption =
        double.tryParse(json['peak_consumption'].toString()) ?? 0.0;
  }
}

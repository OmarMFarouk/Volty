class DashModel {
  WeeklyConsumptionModel? weeklyConsumption;
  bool? success;
  String? message;
  double? currentWHRate, todayWHConsumption, todakWHPeak, loadPercentage;

  DashModel({
    this.success,
    this.message,
    this.currentWHRate,
    this.todakWHPeak,
    this.todayWHConsumption,
    this.loadPercentage,
  });
  DashModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    weeklyConsumption = json['weekly_consumption'] != null
        ? WeeklyConsumptionModel.fromJson(json['weekly_consumption'])
        : null;
    currentWHRate = double.tryParse(json['current_wh_rate'].toString()) ?? 0;
    todayWHConsumption =
        double.tryParse(json['today_total_consumption'].toString()) ?? 0;
    todakWHPeak =
        double.tryParse(json['today_peak_consumption'].toString()) ?? 0;
    loadPercentage = double.tryParse(json['load_percentage'].toString()) ?? 0;
  }
}

class WeaklyDayData {
  String? day;
  String? dayFull;
  String? date;
  double? consumption;
  double? normalizedValue;
  bool? isToday;

  WeaklyDayData({
    this.day,
    this.dayFull,
    this.date,
    this.consumption,
    this.normalizedValue,
    this.isToday,
  });

  WeaklyDayData.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    dayFull = json['day_full'];
    date = json['date'];
    consumption = double.tryParse(json['consumption'].toString()) ?? 0.0;
    normalizedValue =
        double.tryParse(json['normalized_value'].toString()) ?? 0.0;
    isToday = json['is_today'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['day_full'] = dayFull;
    data['date'] = date;
    data['consumption'] = consumption;
    data['normalized_value'] = normalizedValue;
    data['is_today'] = isToday;
    return data;
  }
}

class WeeklyConsumptionModel {
  List<WeaklyDayData>? weeklyData;
  double? totalThisWeek;
  double? totalLastWeek;
  double? percentageChange;
  bool? isIncrease;

  WeeklyConsumptionModel({
    this.weeklyData,
    this.totalThisWeek,
    this.totalLastWeek,
    this.percentageChange,
    this.isIncrease,
  });

  WeeklyConsumptionModel.fromJson(Map<String, dynamic> json) {
    weeklyData = <WeaklyDayData>[];
    if (json['weekly_data'] != null) {
      json['weekly_data'].forEach((v) {
        weeklyData!.add(WeaklyDayData.fromJson(v));
      });
    }
    totalThisWeek = double.tryParse(json['total_this_week'].toString()) ?? 0.0;
    totalLastWeek = double.tryParse(json['total_last_week'].toString()) ?? 0.0;
    percentageChange =
        double.tryParse(json['percentage_change'].toString()) ?? 0.0;
    isIncrease = json['is_increase'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weeklyData != null) {
      data['weekly_data'] = weeklyData!.map((v) => v.toJson()).toList();
    }
    data['total_this_week'] = totalThisWeek;
    data['total_last_week'] = totalLastWeek;
    data['percentage_change'] = percentageChange;
    data['is_increase'] = isIncrease;
    return data;
  }
}

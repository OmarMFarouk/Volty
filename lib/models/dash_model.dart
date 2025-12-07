class DashModel {
  bool? success;
  String? message;
  double? currentKwhRate, todayKwhConsumption, todakKwhPeak, loadPercentage;

  DashModel({
    this.success,
    this.message,
    this.currentKwhRate,
    this.todakKwhPeak,
    this.todayKwhConsumption,
    this.loadPercentage,
  });
  DashModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    currentKwhRate = double.tryParse(json['current_kwh_rate'].toString()) ?? 0;
    todayKwhConsumption =
        double.tryParse(json['today_total_consumption'].toString()) ?? 0;
    todakKwhPeak =
        double.tryParse(json['today_peak_consumption'].toString()) ?? 0;
    loadPercentage = double.tryParse(json['load_percentage'].toString()) ?? 0;
  }
}

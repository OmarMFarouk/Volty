import 'package:flutter/material.dart';
import 'package:volty/enums/devices_types_enum.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/src/app_localization.dart';

class Device {
  int? id;
  String? type;
  String? houseId;
  int? roomId;
  String? name;
  String? state;
  String? createdById;
  String? createdByName;
  String? dateCreated;
  String? dateModified;
  double? whValue;
  double? monthConsumption;
  double? monthUptime;
  double? monthSessions;
  double? totalConsumption;
  double? totalUptime;
  double? totalSessions;
  String? onTimestamp; // New field for the start timestamp

  Device({
    this.id = 0,
    this.houseId,
    this.roomId,
    this.name,
    this.whValue,
    this.state,
    this.type,
    this.createdByName,
    this.createdById,
    this.dateCreated,
    this.dateModified,
    this.monthConsumption,
    this.monthUptime,
    this.monthSessions,
    this.totalConsumption,
    this.totalUptime,
    this.totalSessions,
    this.onTimestamp,
  });

  String get roomName =>
      AppGlobals.devicesModel!.rooms
          ?.firstWhere((r) => r!.id! == roomId)
          ?.name ??
      "N/A";

  double get deviceLoad {
    final total = (AppGlobals.dashModel?.currentWHRate ?? 1);
    final load = double.parse(
      (((whValue ?? 0) / (total == 0 ? 1 : total)) * 100).toStringAsFixed(2),
    );
    return load > 100 ? 100 : load;
  }

  // Calculate current on duration from timestamp
  int getCurrentOnDuration() {
    if (state != "on" || onTimestamp == null || onTimestamp!.isEmpty) {
      return 0;
    }

    try {
      DateTime startTime = DateTime.parse(onTimestamp!.replaceAll(' ', 'T'));
      Duration difference = DateTime.now().difference(startTime);
      return difference.inSeconds;
    } catch (e) {
      return 0;
    }
  }

  String onTime(context) {
    bool isArabic = AppLocalization.isArabic(context);

    // Use timestamp if device is on, otherwise use stored onDuration
    int seconds = 0;
    if (isOn && onTimestamp != null && onTimestamp!.isNotEmpty) {
      seconds = getCurrentOnDuration();
    }

    double minutes = (seconds / 60).abs();
    double hours = minutes / 60;
    double days = hours / 24; // Fixed: 24 hours in a day, not 64

    if (days >= 1) {
      return isArabic
          ? "منذ ${days.toStringAsFixed(1)} يوم"
          : "Uptime ${days.toStringAsFixed(1)} days";
    } else if (hours >= 1) {
      return isArabic
          ? "منذ ${hours.toStringAsFixed(1)} ساعة"
          : "Uptime ${hours.toStringAsFixed(1)} hours";
    } else if (minutes >= 1) {
      return isArabic
          ? "منذ ${minutes.toStringAsFixed(0)} دقيقة"
          : "Uptime ${minutes.toStringAsFixed(0)} minutes";
    }
    return isArabic ? "منذ $seconds ثانية" : "Uptime $seconds seconds";
  }

  Device.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['device_id'].toString());
    type = json['device_type'];
    houseId = json['device_hid'];
    roomId = int.tryParse(json['device_rid'].toString());
    name = json['device_name'];
    state = json['device_state'];
    onTimestamp = json['device_onTimestamp']; // New field
    createdById = json['device_createdBy'];
    createdByName = json['created_by_username'];
    dateCreated = json['device_dateCreated'];
    dateModified = json['device_dateModified'];
    whValue = double.tryParse(json['device_wh'].toString()) ?? 0;
    monthConsumption =
        double.tryParse(json['total_month_consumption'].toString()) ?? 0;
    totalConsumption =
        double.tryParse(json['total_consumption'].toString()) ?? 0;
    monthUptime = double.tryParse(json['total_month_on_hours'].toString()) ?? 0;
    totalUptime = double.tryParse(json['total_on_hours'].toString()) ?? 0;
    monthSessions =
        double.tryParse(json['total_month_sessions'].toString()) ?? 0;
    totalSessions = double.tryParse(json['total_sessions'].toString()) ?? 0;
  }

  IconData get icon => DeviceTypes.getIcon(type);
  bool get isOn => state == "on";
  bool get isOff => state == "off";

  Map<String, dynamic> manageJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) data['device_id'] = id.toString();
    data['device_hid'] = AppGlobals.currentHouse!.id.toString();
    data['device_rid'] = roomId.toString();
    data['device_name'] = name;
    data['device_type'] = type;
    data['device_wh'] = whValue.toString();
    return data;
  }
}

class RoomModel {
  int? id;
  String? houseId;
  String? name;
  String? createdById;
  String? createdByName;
  String? dateCreated;
  String? dateModified;
  List<Device?>? devices;

  RoomModel({
    this.id = 0,
    this.houseId,
    this.name,
    this.createdById,
    this.createdByName,
    this.dateCreated,
    this.dateModified,
    this.devices,
  });
  int get totalCount => devices?.length ?? 0;
  int get activeCount => devices?.where((r) => r?.isOn ?? false).length ?? 0;
  int get inactiveCount => devices?.where((r) => r?.isOff ?? true).length ?? 0;
  RoomModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['room_id'].toString()) ?? 0;
    houseId = json['room_hid'];
    name = json['room_name'];
    createdById = json['room_createdBy'];
    createdByName = json['created_by_username'];
    dateCreated = json['room_dateCreated'];
    dateModified = json['room_dateModified'];
    if (json['devices'] != null) {
      devices = <Device>[];
      json['devices'].forEach((v) {
        devices!.add(Device.fromJson(v));
      });
    }
  }
  Map<String, dynamic> manageJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != 0) data['room_id'] = id.toString();
    data['room_hid'] = AppGlobals.currentHouse!.id.toString();
    data['room_name'] = name.toString();
    return data;
  }
}

class DevicesModel {
  bool? success;
  String? message;
  List<RoomModel?>? rooms;

  DevicesModel({this.success, this.message, this.rooms});
  int get roomsCount => rooms?.length ?? 0;
  int get activeRoomsCount =>
      rooms?.where((d) => (d?.activeCount ?? 0) > 1).length ?? 0;
  int get devicesCount => rooms?.expand((r) => r?.devices ?? []).length ?? 0;
  int get activeCount =>
      rooms
          ?.expand((r) => r?.devices ?? [])
          .where((d) => d.isOn == true)
          .length ??
      0;
  int get inactiveCount =>
      rooms
          ?.expand((r) => r?.devices ?? [])
          .where((d) => d.isOn == false)
          .length ??
      0;

  DevicesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['rooms'] != null) {
      rooms = <RoomModel>[];
      json['rooms'].forEach((v) {
        rooms!.add(RoomModel.fromJson(v));
      });
    }
  }
}

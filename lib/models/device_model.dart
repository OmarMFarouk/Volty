import 'package:flutter/material.dart';
import 'package:volty/enums/devices_types_enum.dart';
import 'package:volty/src/app_globals.dart';

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
  });
  String get roomName =>
      AppGlobals.devicesModel!.rooms
          ?.firstWhere((r) => r!.id! == roomId)
          ?.name ??
      "N/A";
  double get deviceLoad {
    double totalLoad = AppGlobals.dashModel?.currentWHRate ?? 1;
    return (whValue ?? 0) / totalLoad * 100;
  }

  Device.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['device_id'].toString());
    type = json['device_type'];
    houseId = json['device_hid'];
    roomId = int.tryParse(json['device_rid'].toString());
    name = json['device_name'];
    state = json['device_state'];
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

  set toggle(currState) => currState == 'on' ? "off" : "on";
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

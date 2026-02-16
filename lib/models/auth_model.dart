import 'package:flutter/material.dart';

class Household {
  String? id;
  String? name;
  String? rawAddress;
  String? ownerUID;
  String? currentTemp;
  int? devicesCount;
  int? roomsCount;
  String? dateCreated;
  String get houseCity {
    String target = rawAddress?.split('§§')[0] ?? "";

    return target.split(' ')[0];
  }

  String get houseAddress {
    String target = rawAddress?.split('§§')[1] ?? "";

    return target.split(' ')[0];
  }

  String get houseCountry {
    String target = rawAddress?.split('§§')[2] ?? "";

    return target.split(' ')[0];
  }

  IconData get currentTempIcon {
    double temp = double.tryParse(currentTemp ?? '25') ?? 25.0;

    if (temp > 25) return Icons.wb_sunny;
    if (temp > 20) return Icons.wb_cloudy;
    if (temp > 15) return Icons.cloud;
    if (temp > 10) return Icons.cloud_queue;
    return Icons.ac_unit;
  }

  Household({
    this.id,
    this.name,
    this.rawAddress,
    this.ownerUID,
    this.currentTemp,
    this.dateCreated,
    this.devicesCount,
    this.roomsCount,
  });
  Map<String, dynamic> manageJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != '0') data['household_id'] = id.toString();
    data['household_name'] = name;
    data['household_address'] = rawAddress;

    return data;
  }

  Household.fromJson(Map<String, dynamic> json) {
    id = json['household_id'];
    name = json['household_name'];
    rawAddress = json['household_address'];
    ownerUID = json['household_ownerId'];
    currentTemp = json['house_temp'].toString();
    roomsCount = int.tryParse(json['household_roomsCount'].toString()) ?? 0;
    devicesCount = int.tryParse(json['household_devicesCount'].toString()) ?? 0;
    dateCreated = json['household_dateCreated'];
  }
}

class AuthModel {
  bool? success;
  String? message;
  User? user;
  Household? household;
  List<Household>? houses;

  AuthModel({this.success, this.message, this.user, this.household});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? User?.fromJson(json['user']) : null;
    household = json['household'] != null
        ? Household?.fromJson(json['household'])
        : null;
    houses = <Household>[];
    if (json['houses'] != null) {
      json['houses'].forEach((v) {
        houses!.add(Household.fromJson(v));
      });
    }
  }
}

class User {
  String? userId;
  String? householdId;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? fcmToken;
  String? userimage;
  String? lastAccess;
  String? dateCreated;
  String? dateModified;

  User({
    this.userId,
    this.householdId,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.fcmToken,
    this.userimage,
    this.lastAccess,
    this.dateCreated,
    this.dateModified,
  });
  int? get daysSince =>
      DateTime.now().difference(DateTime.parse(dateCreated!)).inDays;
  String get initials => (name![0] + name!.split(' ').last[0]).toUpperCase();
  loginJson() => {"user_email": email, "user_password": password};
  createJson({required String houseAddress, required String houseName}) => {
    "user_name": name,
    "user_email": email,
    "user_password": password,
    "user_phone": phone,
    "user_fcmToken": "device error",
    "household_name": houseName,
    "household_address": houseAddress,
  };
  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    householdId = json['user_hid'];
    name = json['user_name'];
    email = json['user_email'];
    phone = json['user_phone'];
    password = json['user_password'];
    fcmToken = json['user_fcmToken'];
    userimage = json['user_image'] ?? "";
    lastAccess = json['user_lastAccess'];
    dateCreated = json['user_dateCreated'];
    dateModified = json['user_dateModified'];
  }
}

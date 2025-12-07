import 'dart:convert';
import 'dart:developer';
import 'package:volty/models/device_model.dart';

import '../../src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../src/app_secured.dart';

class DevicesApi {
  Future<dynamic> fetchDevices() async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.get(
        Uri.parse(AppEndPoints.showDevices),
        headers: {"Authorization": "Bearer $token"},
      );

      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("FetchingDevices error: $e");
      return "error $e";
    }
  }

  Future<dynamic> manageDevices(Device device) async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.post(
        Uri.parse(AppEndPoints.manageDevice),
        body: device.manageJson(),
        headers: {"Authorization": "Bearer $token"},
      );

      log(device.manageJson().toString());
      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("ManageDevice error: $e");
      return "error $e";
    }
  }

  Future<dynamic> manageRooms(RoomModel room) async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.post(
        Uri.parse(AppEndPoints.manageRoom),
        body: room.manageJson(),
        headers: {"Authorization": "Bearer $token"},
      );

      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("ManageRooms error: $e");
      return "error $e";
    }
  }

  Future<dynamic> toggleDevice(int deviceId) async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.post(
        Uri.parse(AppEndPoints.alterDevice),
        body: {"device_id": deviceId.toString()},
        headers: {"Authorization": "Bearer $token"},
      );

      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("ManageRooms error: $e");
      return "error $e";
    }
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:volty/models/auth_model.dart';

import '../../src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../src/app_secured.dart';

class DashApi {
  Future<dynamic> fetchDashboard() async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.get(
        Uri.parse(AppEndPoints.showDashboard),
        headers: {"Authorization": "Bearer $token"},
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("fetchDashboard error: $e");
      return {"error": e.toString()};
    }
  }

  Future<dynamic> manageHousehold(Household household) async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.post(
        Uri.parse(AppEndPoints.manageHousehold),
        body: household.manageJson(),
        headers: {"Authorization": "Bearer $token"},
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("ManageDevice error: $e");
      return "error $e";
    }
  }

  Future<dynamic> switchHousehold(String householdId) async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.post(
        Uri.parse(AppEndPoints.switchHousehold),
        body: {"household_id": householdId},
        headers: {"Authorization": "Bearer $token"},
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("fetchDashboard error: $e");
      return {"error": e.toString()};
    }
  }
}

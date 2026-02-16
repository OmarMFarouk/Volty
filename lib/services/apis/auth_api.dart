import 'dart:convert';
import 'dart:developer';

import '../../models/auth_model.dart';
import '../../src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../src/app_secured.dart';

class AuthApi {
  Future<dynamic> createOwner({
    required User model,
    required String houseName,
    required String houseAddress,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppEndPoints.createUser),
        body: model.createJson(
          houseAddress: houseAddress,
          houseName: houseName,
        ),
      );

      log(
        model
            .createJson(houseAddress: houseAddress, houseName: houseName)
            .toString(),
      );
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("createOwner error: $e");
      return "error $e";
    }
  }

  Future<dynamic> loginUser({required User model}) async {
    final token = await AppSecured.readString('user_token') ?? "";

    try {
      final response = await http.post(
        Uri.parse(AppEndPoints.loginUser),
        body: model.loginJson(),
        headers: {"Authorization": "Bearer $token"},
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("loginUser error: $e");
      return {"error": e.toString()};
    }
  }

  Future<dynamic> resetPassword({required String email}) async {
    final token = await AppSecured.readString('user_token') ?? "";
    try {
      final response = await http.post(
        Uri.parse(AppEndPoints.resetPassword),
        body: {"user_email": email},
        headers: {"Authorization": "Bearer $token"},
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("resetPassword error: $e");
      return "error $e";
    }
  }

  Future<dynamic> tokenChecker() async {
    final token = await AppSecured.readString('user_token') ?? "";
    try {
      final response = await http.get(
        Uri.parse(AppEndPoints.tokenChecker),
        headers: {"Authorization": "Bearer $token"},
      );
      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("tokenChecker error: $e");
      return "error $e";
    }
  }

  Future<dynamic> changePassword({required String newPassword}) async {
    final token = await AppSecured.readString('user_token') ?? "";

    try {
      final response = await http.post(
        Uri.parse(AppEndPoints.changePassword),
        body: {"new_password": newPassword},
        headers: {"Authorization": "Bearer $token"},
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("changePassword error: $e");
      return "error $e";
    }
  }
}

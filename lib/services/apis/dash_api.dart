import 'dart:convert';
import 'dart:developer';
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

      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("createOwner error: $e");
      return {"error": e.toString()};
    }
  }
}

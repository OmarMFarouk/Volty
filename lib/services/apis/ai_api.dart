import 'dart:convert';
import 'dart:developer';
import '../../src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../src/app_secured.dart';

class AIApi {
  Future<dynamic> fetchFeatures() async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.get(
        Uri.parse(AppEndPoints.showFeatures),
        headers: {"Authorization": "Bearer $token"},
      );

      log(response.body.toString());
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("fetchFeatures error: $e");
      return "error $e";
    }
  }
}

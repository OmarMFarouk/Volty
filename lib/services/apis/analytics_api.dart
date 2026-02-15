import 'dart:convert';
import 'dart:developer';
import '../../src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../src/app_secured.dart';

class AnalyticsApi {
  Future<dynamic> fethcAnalytics({required String period, String? date}) async {
    try {
      final token = await AppSecured.readString('user_token') ?? "";
      final response = await http.post(
        Uri.parse(AppEndPoints.showAnalytics),
        body: {
          'period': period,
          'date': date ?? DateTime.now().toIso8601String().split('T')[0],
        },
        headers: {"Authorization": "Bearer $token"},
      );

      log("analytics ${response.body.toString()}");
      return jsonDecode(response.body);
    } on Exception catch (e) {
      log("fethcAnalytics error: $e");
      return "error $e";
    }
  }
}

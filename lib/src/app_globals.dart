import 'package:volty/models/analytics_model.dart';
import 'package:volty/models/auth_model.dart';
import 'package:volty/models/device_model.dart';

import '../models/dash_model.dart';

class AppGlobals {
  static User? currentUser;
  static Household? currentHouse;
  static DashModel? dashModel;
  static DevicesModel? devicesModel;
  static AnalyticsModel? analyticsModel;

  static bool isModelsInitialized() {
    return currentHouse != null &&
        currentUser != null &&
        dashModel != null &&
        devicesModel != null;
  }
}

import 'package:volty/models/ai_model.dart';
import 'package:volty/models/analytics_model.dart';
import 'package:volty/models/auth_model.dart';
import 'package:volty/models/device_model.dart';

import '../models/dash_model.dart';

class AppGlobals {
  static User? currentUser;
  static Household? currentHouse;
  static List<Household>? allHouses;
  static DashModel? dashModel;
  static AiModel? aiModel;
  static DevicesModel? devicesModel;
  static AnalyticsModel? analyticsModel;

  static bool isModelsInitialized() {
    return currentHouse != null &&
        currentUser != null &&
        dashModel != null &&
        allHouses != null &&
        devicesModel != null &&
        aiModel != null;
  }
}

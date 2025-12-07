import 'package:shared_preferences/shared_preferences.dart';
import 'app_secured.dart';

class AppShared {
  static late SharedPreferences localStorage;
  static Future<void> init() async {
    localStorage = await SharedPreferences.getInstance();

    if (localStorage.getBool('showcased') == null) {
      AppSecured.clear();
      await localStorage.setBool('showcased', false);
    }
    if (localStorage.getBool('onboarded') == null) {
      await localStorage.setBool('onboarded', false);
    }
  }
}

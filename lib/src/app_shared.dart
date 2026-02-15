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
    await isFirstOpen();
  }

  static Future<bool> isFirstOpen() async {
    if (localStorage.getBool('first_time') == null) {
      await AppSecured.clear();
      await localStorage.setBool('first_time', true);
    }

    final noLogin = (await AppSecured.readString('user_token') ?? "").isEmpty;
    if (noLogin) {
      localStorage.setBool('no_login', true);
      return true;
    }
    return localStorage.getBool('first_time')!;
  }

  static Future<void> saveToken(token) async {
    if (await isFirstOpen()) {
      await localStorage.setBool('first_time', false);
    }
    await AppSecured.saveString('user_token', token);
  }
}

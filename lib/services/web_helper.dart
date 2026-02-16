import 'package:flutter/foundation.dart';
import 'package:restart_app/restart_app.dart';
import 'package:universal_html/universal_html.dart' as html;

class ReloadHelper {
  static void reloadPage() async {
    if (kIsWeb) {
      return html.window.location.reload();
    }
    return await Future.delayed(
      Duration(seconds: 4),
      () => Restart.restartApp(),
    );
  }
}

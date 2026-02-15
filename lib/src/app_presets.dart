import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:volty/blocs/analytics_bloc/cubit.dart';
import 'package:volty/blocs/dash_bloc/dash_cubit.dart';
import 'package:volty/blocs/devices_bloc/cubit.dart';
import '../views/auth/error_screen.dart';
import 'app_globals.dart';
import 'app_localization.dart';
import 'app_navigator.dart';
import 'app_shared.dart';

class AppPresets {
  static late String appVersion;
  static init() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.blueGrey,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await AppLocalization.init();
    await AppShared.init();
    await initializeDateFormatting('ar_EG', null);
    Intl.defaultLocale = 'ar_EG';
  }

  static Future<bool> initData(BuildContext context) async {
    try {
      await Future.wait([
        BlocProvider.of<DashCubit>(context).fetchDashboard(),
        BlocProvider.of<DevicesCubit>(context).fetchDevices(),
        BlocProvider.of<AnalyticsCubit>(context).fetchAnalytics(),
      ]);
      if (!AppGlobals.isModelsInitialized()) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => AppNavigator.pushR(
            context,
            ErrorScreen(
              errorMsg: AppGlobals.isModelsInitialized()
                  ? ""
                  : "برجاء تفقد الإتصال بلشبكة",
              icon: AppGlobals.isModelsInitialized()
                  ? FontAwesomeIcons.tools
                  : Icons.signal_wifi_connected_no_internet_4_sharp,
            ),
            NavigatorAnimation.slideAnimation,
          ),
        );
        return false;
      }
      return true;
    } catch (e) {
      AppNavigator.pushR(
        context,
        ErrorScreen(errorMsg: e.toString(), icon: Icons.hourglass_bottom),
        NavigatorAnimation.slideAnimation,
      );
      return false;
    }
  }
}

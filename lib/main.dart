import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'observer/bloc.dart';
import 'services/overrides.dart';
import 'src/app_presets.dart';
import 'src/app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPresets.init();
  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = MyBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', 'EG'),
      child: const AppRoot(),
    ),
  );
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  static setLocale(newLocale, BuildContext context) =>
      context.setLocale(newLocale);
  static setArLocale(BuildContext context) =>
      context.setLocale(Locale("ar", "EG"));
  static setEnLocale(BuildContext context) =>
      context.setLocale(Locale("en", "US"));
  static switchLocale(newLocale, BuildContext context) =>
      context.locale.languageCode == "ar"
      ? setArLocale(context)
      : setEnLocale(context);

  static Locale getLocale(BuildContext context) => context.locale;
  static bool isEnglish(BuildContext context) =>
      context.locale.languageCode == "en";
  static bool isArabic(BuildContext context) =>
      context.locale.languageCode == "ar";
  static Future<void> init() async =>
      await EasyLocalization.ensureInitialized();
}

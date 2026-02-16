import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:volty/src/app_colors.dart';

class MyToast {
  static void show(BuildContext context, msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColors.primary.withOpacity(0.7),
      textColor: AppColors.primaryFont,
    );
  }
}

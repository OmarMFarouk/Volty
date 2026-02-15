import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../components/general/snackbar.dart';

import '../../src/app_colors.dart';

class MyLoadingIndicator {
  static showLoader(BuildContext context, {bool canPop = false}) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        Future.delayed(Duration(seconds: 12), () {
          if (dialogContext.mounted) {
            MySnackBar.show(
              context: context,
              isAlert: true,
              text: "حدث خطأ جرب لاحقًا",
            );
            Navigator.pop(dialogContext);
          }
        });
        return PopScope(
          canPop: canPop,
          child: FractionallySizedBox(
            widthFactor: 0.25,
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: AppColors.primaryGradient,
                  ),
                ),
                // Image.asset('assets/images/loading.gif'),
                // Material(
                //   color: Colors.transparent,
                //   child: Text(
                //     '...يتم المعاجلة',
                //     style: TextStyle(color: AppColors.primaryFont),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },

      barrierDismissible: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:volty/src/app_colors.dart';
import 'package:volty/views/auth/login.dart';
import 'package:volty/views/auth/signup.dart';
import 'package:volty/views/auth/welcome.dart';

import '../../components/general/snackbar.dart';

class AuthIndex extends StatefulWidget {
  const AuthIndex({super.key});

  @override
  State<AuthIndex> createState() => _AuthIndexState();
}

class _AuthIndexState extends State<AuthIndex> {
  PageController pageController = PageController();
  bool canPop = false;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastLinearToSlowEaseIn,
          );
          return false;
        } else {
          if (!canPop) {
            canPop = true;
            MySnackBar.show(
              context: context,
              isAlert: true,
              text: 'هل انت متأكد؟',
            );
            Future.delayed(const Duration(seconds: 2), () {
              canPop = false;
            });
            return false;
          }
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backGround,
        body: PageView(
          onPageChanged: (value) => currentIndex = value,
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            WelcomeScreen(pageController: pageController),
            LoginScreen(pageController: pageController),
            SignupScreen(pageController: pageController),
          ],
        ),
      ),
    );
  }
}

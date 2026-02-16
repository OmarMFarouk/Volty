import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_colors.dart';

import '../../components/general/snackbar.dart';
import '../../components/main_index/navbar.dart';
import '../../src/app_string.dart';
import 'analytics.dart';
import 'dashboard.dart';
import 'devices.dart';
import 'profile.dart';

class MainIndex extends StatefulWidget {
  const MainIndex({super.key});

  @override
  State<MainIndex> createState() => _MainIndexState();
}

final PageController mainPageController = PageController();

class _MainIndexState extends State<MainIndex> {
  int _selectedIndex = 0;
  bool canPop = false;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const DevicesScreen(),
    const AnalyticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!canPop) {
          canPop = true;
          MySnackBar.show(
            context: context,
            isAlert: true,
            text: AppString.sureMsg.tr(),
          );
          Future.delayed(const Duration(seconds: 2), () {
            canPop = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backGround,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _screens.length,
              itemBuilder: (context, index) => _screens[index],
              controller: mainPageController,
              onPageChanged: (value) => setState(() => _selectedIndex = value),
            ),

            MyNavBar(
              currentIndex: _selectedIndex,
              pageController: mainPageController,
            ),
          ],
        ),
      ),
    );
  }
}

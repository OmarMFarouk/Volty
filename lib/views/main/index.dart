import 'package:flutter/material.dart';

import '../../components/main_index/navbar.dart';
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
  final List<Widget> _screens = [
    const DashboardScreen(),
    const DevicesScreen(),
    const AnalyticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
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
    );
  }
}

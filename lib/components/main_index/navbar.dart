import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_string.dart';
import '../../src/app_colors.dart';
import '../general/my_animation.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar({
    super.key,
    required this.currentIndex,
    required this.pageController,
  });
  final int currentIndex;
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(context.locale),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF1E2538),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, AppString.home, 0),
          _buildNavItem(Icons.devices_other_rounded, AppString.devicesTitle, 1),
          _buildNavItem(Icons.analytics_rounded, AppString.analytics, 2),
          _buildNavItem(Icons.person_rounded, AppString.account, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    final shouldAnimate = (currentIndex - index).abs() == 1;
    return MyCustomAnimation(
      duration: (index + 1) * 200 + 500,
      child: GestureDetector(
        onTap: () => shouldAnimate
            ? pageController.animateToPage(
                index,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(milliseconds: 300),
              )
            : pageController.jumpToPage(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.grey,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label.tr(),
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.grey,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:volty/src/app_shared.dart";
import "package:volty/views/auth/index.dart";
import "../../src/app_colors.dart";
import "../../src/app_localization.dart";
import "../../src/app_navigator.dart";
import "../../src/app_string.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.auto_awesome_rounded,
      title: AppString.onboardingTitle1,
      description: AppString.onboardingDesc1,
      gradient: AppColors.secondaryGradient,
    ),
    OnboardingData(
      icon: Icons.analytics_rounded,
      title: AppString.onboardingTitle2,
      description: AppString.onboardingDesc2,
      gradient: AppColors.tertiaryGradient,
    ),
    OnboardingData(
      icon: Icons.savings_rounded,
      title: AppString.onboardingTitle3,
      description: AppString.onboardingDesc3,
      gradient: AppColors.orangeGradient,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      AppShared.localStorage.setBool('onboarded', true);
                      AppNavigator.pushR(
                        context,
                        AuthIndex(),
                        NavigatorAnimation.fadeAnimation,
                      );
                    },
                    child: Text(
                      AppString.skip.tr(),
                      style: TextStyle(
                        color: AppColors.primaryFont.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildLanguageDropdown(),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildIndicator(index == _currentPage),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF27AE60)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            AppShared.localStorage.setBool('onboarded', true);
                            AppNavigator.pushR(
                              context,
                              AuthIndex(),
                              NavigatorAnimation.fadeAnimation,
                            );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? AppString.start.tr()
                              : AppString.next.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: data.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.gradient[0].withOpacity(0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(data.icon, size: 100, color: Colors.white),
          ),
          const SizedBox(height: 60),
          Text(
            data.title.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryFont,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryFont.withOpacity(0.6),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: DropdownButton<String>(
        value: AppLocalization.getLocale(context).languageCode == 'en'
            ? 'English'
            : 'العربية',
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primaryFont.withOpacity(0.8),
          size: 20,
        ),
        underline: const SizedBox(),
        dropdownColor: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        style: TextStyle(
          color: AppColors.primaryFont.withOpacity(0.8),
          fontSize: 14,
        ),
        items: const [
          DropdownMenuItem(
            value: 'العربية',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('🇪🇬'), SizedBox(width: 8), Text('العربية')],
            ),
          ),
          DropdownMenuItem(
            value: 'English',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('🇺🇸'), SizedBox(width: 8), Text('English')],
            ),
          ),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            AppLocalization.setLocale(
              newValue == 'English'
                  ? const Locale('en', "US")
                  : const Locale('ar', "EG"),
              context,
            );
          }
        },
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

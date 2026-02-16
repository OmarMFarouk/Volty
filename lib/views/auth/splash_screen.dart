import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:volty/models/auth_model.dart';
import 'package:volty/services/web_helper.dart';
import 'package:volty/src/app_string.dart';
import 'package:volty/views/main/index.dart';
import '../../src/app_globals.dart';
import 'error_screen.dart';
import '../../services/apis/auth_api.dart';
import '../../src/app_assets.dart';
import '../../src/app_presets.dart';
import '../../src/app_colors.dart';
import '../../src/app_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _loadingOpacityAnimation;
  late Animation<double> _backgroundAnimation;
  int _timePassed = 0;
  bool _showLoading = false;
  String _statusText = 'جارٍ التحميل...';

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
    Timer.periodic(const Duration(seconds: 1), (r) {
      if (mounted) setState(() => _timePassed++);
    });
    // Start validity check after initial animations
    Timer(const Duration(milliseconds: 1500), () {
      setState(() => _showLoading = true);
      _loadingController.forward();
      checkValidity(context);
    });
  }

  void _initAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
        );

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _loadingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeOut),
    );

    // Background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() {
    _backgroundController.forward();

    Timer(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });

    Timer(const Duration(milliseconds: 800), () {
      _textController.forward();
    });
  }

  Future checkValidity(BuildContext context) async {
    setState(() => _statusText = 'التحقق من الاتصال...');

    await AuthApi().tokenChecker().then((r) async {
      if (r == null || r.toString().startsWith('error')) {
        setState(() => _statusText = 'خطأ في الاتصال...');
        await Future.delayed(const Duration(milliseconds: 500));

        AppNavigator.pushR(
          context,
          ErrorScreen(
            errorMsg: 'تحقق من الإنترنت',
            icon: Icons.signal_wifi_connected_no_internet_4_outlined,
          ),
          NavigatorAnimation.slideAnimation,
        );
        return;
      } else if (r['success'] == false) {
        setState(() => _statusText = 'خطأ في المصادقة...');
        await Future.delayed(const Duration(milliseconds: 500));

        AppNavigator.pushR(
          context,
          ErrorScreen(errorMsg: r['message'], icon: Icons.hourglass_bottom),
          NavigatorAnimation.slideAnimation,
        );
      } else if (r['success'] == true) {
        setState(() => _statusText = 'تحميل البيانات...');
        if (r['user'] == null || r['household'] == null) {
          AppNavigator.pushR(
            context,
            ErrorScreen(
              errorMsg: 'الحساب غير موجود',
              icon: Icons.not_interested_sharp,
            ),
            NavigatorAnimation.slideAnimation,
          );
          return;
        }
        AppGlobals.currentUser = User.fromJson(r['user']);
        AppGlobals.currentHouse = Household.fromJson(r['household']);
        AppGlobals.allHouses = r['houses'] != null
            ? r['houses'].map<Household>((e) => Household.fromJson(e)).toList()
            : [];
        AppGlobals.allHouses = AppGlobals.allHouses
          ?..sort((a, b) => a.id == AppGlobals.currentHouse!.id ? -1 : 1);

        await initData(context);
      }
    });
  }

  Future initData(BuildContext context) async {
    setState(() => _statusText = 'إعداد التطبيق...');
    var shouldPush = await AppPresets.initData(context);
    if (shouldPush) {
      setState(() => _statusText = 'مرحباً بك!');
      await Future.delayed(const Duration(milliseconds: 2000));

      AppNavigator.pushR(
        context,
        const MainIndex(),
        NavigatorAnimation.fadeAnimation,
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.0 + (_backgroundAnimation.value * 0.2),
                  1.0 - (_backgroundAnimation.value * 0.2),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top spacer
                  if (_timePassed > 6)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => ReloadHelper.reloadPage(),
                          icon: Row(
                            children: [
                              Text(
                                'إعادة التحميل',
                                style: TextStyle(color: AppColors.primaryFont),
                              ),
                              Icon(
                                Icons.restart_alt,
                                color: AppColors.primaryFont,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: screenHeight * 0.15),

                  // Main content area
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogoSection(screenHeight, screenWidth, isTablet),
                        SizedBox(height: screenHeight * 0.04),
                        _buildAppTitle(isTablet),
                        SizedBox(height: screenHeight * 0.06),
                        _buildSubtitle(isTablet),
                      ],
                    ),
                  ),

                  // Loading section at bottom
                  _buildLoadingSection(screenHeight, isTablet),
                  SizedBox(height: screenHeight * 0.08),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection(
    double screenHeight,
    double screenWidth,
    bool isTablet,
  ) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 5,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated glow rings
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                  // Logo icon - Replace with your actual logo
                  Image.asset(AppAssets.logo, scale: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppTitle(bool isTablet) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textOpacityAnimation,
            child: Column(
              children: [
                Text(
                  AppString.appTitle.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryFont,
                    fontSize: isTablet ? 36 : 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: AppColors.primary.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle(bool isTablet) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textOpacityAnimation,
          child: Text(
            AppString.appShortDesc.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryFont.withOpacity(0.7),
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection(double screenHeight, bool isTablet) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        if (!_showLoading) return const SizedBox.shrink();

        return FadeTransition(
          opacity: _loadingOpacityAnimation,
          child: Column(
            children: [
              // Loading indicator
              SizedBox(
                width: isTablet ? 60 : 50,
                height: isTablet ? 60 : 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotate,
                  colors: AppColors.tertiaryGradient,
                  strokeWidth: 2,
                ),
              ),

              const SizedBox(height: 20),

              // Status text
              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 300),
              //   child: Text(
              //     _statusText,
              //     key: ValueKey(_statusText),
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       color: AppColors.primaryFont.withOpacity(0.8),
              //       fontSize: isTablet ? 16 : 14,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(
                        _statusText.contains('تحميل') ||
                                _statusText.contains('إعداد')
                            ? (index <= 1 ? 1.0 : 0.3)
                            : _statusText.contains('التحقق')
                            ? (index == 0 ? 1.0 : 0.3)
                            : 0.3,
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

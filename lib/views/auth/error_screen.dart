import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volty/services/web_helper.dart';
import '../../src/app_navigator.dart';
import '../../src/app_colors.dart';
import 'index.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key, required this.errorMsg, required this.icon});

  final String errorMsg;
  final IconData icon;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the error icon
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Slide animation for the container
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    // Start animations
    _pulseController.repeat(reverse: true);
    _slideController.forward();

    // Add haptic feedback
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated error icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.red.withOpacity(0.3),
                            Colors.red.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 80,
                        color: Colors.red.shade400,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Fatal error title
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'حدث خطأ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryFont,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Error message container
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.tertiaryGradient,
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),

                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Error icon in message
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade300,
                        size: 40,
                      ),

                      const SizedBox(height: 15),

                      // Error message
                      Text(
                        widget.errorMsg,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryFont,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Divider
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.primary.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Technical message
                      Text(
                        'تعذر تشغيل التطبيق بسبب خطأ غير متوقع',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryFont.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Action buttons
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  spacing: 35,
                  children: [
                    _buildActionButton(
                      icon: Icons.refresh_rounded,
                      text: 'حاول مجددًا',

                      isPrimary: true,
                    ),
                    _buildActionButton(
                      icon: Icons.login,
                      text: 'الرجوع للتسجيل',

                      isPrimary: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Footer message
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'إذا استمر هذا الخطأ، يرجى التواصل مع فريق الدعم',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryFont.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,

    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: text.contains('للتسجيل')
          ? () => AppNavigator.pushR(
              context,
              AuthIndex(),
              NavigatorAnimation.fadeAnimation,
            )
          : () => ReloadHelper.reloadPage(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: AppColors.secondaryGradient,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
              : LinearGradient(
                  colors: AppColors.secondaryGradient,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),

          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isPrimary
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.5),
            width: isPrimary ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? AppColors.tertiary
                  : AppColors.primary.withOpacity(0.8),
              size: 20,
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
                color: AppColors.tertiary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

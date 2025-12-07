import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_assets.dart';
import 'package:volty/src/app_localization.dart';
import 'package:volty/src/app_string.dart';

import '../../src/app_colors.dart';

// Import your AppColors here
// import 'app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A), // AppColors.backGround
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 40),
                    _buildAppName(),
                    const SizedBox(height: 20),
                    _buildTagline(),
                    const SizedBox(height: 50),
                    _buildFeatureCards(),
                  ],
                ),
              ),
              _buildActionButtons(context),
              const SizedBox(height: 20),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.secondaryGradient,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8FF57).withOpacity(0.4),
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
    );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          AppString.appTitle.tr(),
          style: TextStyle(
            color: Colors.white, // AppColors.primaryFont
            fontSize: 38,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFB8FF57).withOpacity(0.2),
                const Color(0xFF8FD63F).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFB8FF57).withOpacity(0.3)),
          ),
          child: Text(
            AppString.appShortDesc.tr(),
            style: TextStyle(
              color: Color(0xFFB8FF57),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        AppString.welcomeMsg.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[400], // AppColors.grey
          fontSize: 16,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureCard(
            AppString.welcomeNote1,
            Icons.analytics_rounded,
            const Color(0xFF4ECDC4), // AppColors.green
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildFeatureCard(
            AppString.welcomeNote2,
            Icons.eco_rounded,
            const Color(0xFFB8FF57), // AppColors.primary
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildFeatureCard(
            AppString.welcomeNote3,
            Icons.settings_remote_rounded,
            const Color(0xFF6C63FF), // AppColors.blue
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538), // AppColors.secondary
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D3548)), // AppColors.border
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Sign Up Button (Primary)
        Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB8FF57), Color(0xFF8FD63F)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB8FF57).withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              pageController.animateToPage(
                2,
                duration: Durations.long1,
                curve: Curves.fastLinearToSlowEaseIn,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.signup.tr(),
                  style: TextStyle(
                    color: Color(0xFF0A0E1A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  AppLocalization.isArabic(context)
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios,
                  color: Color(0xFF0A0E1A),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Login Button (Secondary)
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFB8FF57).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              pageController.animateToPage(
                1,
                duration: Durations.long1,
                curve: Curves.fastLinearToSlowEaseIn,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.login.tr(),
                  style: TextStyle(
                    color: Color(0xFFB8FF57),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.login_rounded,
                  color: Color(0xFFB8FF57),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(Icons.facebook),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.link),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.mail_outline),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          'Powered by ET5 • Made with ❤️',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Icon(icon, color: Colors.grey[400], size: 20),
    );
  }
}

// // Alternative Welcome Screen with Animated Background
// class WelcomeScreenAnimated extends StatefulWidget {
//   const WelcomeScreenAnimated({super.key});

//   @override
//   State<WelcomeScreenAnimated> createState() => _WelcomeScreenAnimatedState();
// }

// class _WelcomeScreenAnimatedState extends State<WelcomeScreenAnimated>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0E1A),
//       body: Stack(
//         children: [
//           // Animated background circles
//           Positioned(
//             top: -100,
//             right: -100,
//             child: AnimatedBuilder(
//               animation: _pulseAnimation,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _pulseAnimation.value,
//                   child: Container(
//                     width: 300,
//                     height: 300,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           const Color(0xFFB8FF57).withOpacity(0.1),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             bottom: -150,
//             left: -150,
//             child: AnimatedBuilder(
//               animation: _pulseAnimation,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: 2 - _pulseAnimation.value,
//                   child: Container(
//                     width: 400,
//                     height: 400,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           const Color(0xFF6C63FF).withOpacity(0.1),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Main content
//           const WelcomeScreen(pageController: pageController,),
//         ],
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/blocs/auth_bloc/auth_cubit.dart';
import 'package:volty/blocs/auth_bloc/auth_states.dart';
import 'package:volty/components/general/my_field.dart';
import 'package:volty/components/general/snackbar.dart';
import 'package:volty/src/app_colors.dart';
import 'package:volty/src/app_string.dart';

import '../../components/general/my_loading_indicator.dart';
import '../../src/app_navigator.dart';
import 'splash_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.pageController});
  final PageController pageController;
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int currentStep = 0;
  final PageController _pageController = PageController();
  final formKey = GlobalKey<FormState>();
  late AuthCubit cubit;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  void nextStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (formKey.currentState!.validate()) {
      if (currentStep < 2) {
        setState(() => currentStep++);
        _pageController.animateToPage(
          currentStep,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        return;
      }
      if (currentStep == 2 &&
          _calculatePasswordStrength(cubit.passwordCont.text) == 5) {
        cubit.createUser();
      }
    }
  }

  void previousStep() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (currentStep > 0) {
      setState(() => currentStep--);
      _pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoading) {
          MyLoadingIndicator.showLoader(context);
        }

        if (state is AuthSuccess) {
          MySnackBar.show(context: context, isAlert: false, text: state.msg);
          if (state.shouldNavigate) {
            AppNavigator.pushR(
              context,
              SplashScreen(),
              NavigatorAnimation.slideAnimation,
            );
          }
        }
        if (state is AuthError) {
          MySnackBar.show(context: context, isAlert: true, text: state.msg);
        }
        if (state is AuthLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        cubit = context.read<AuthCubit>();
        return Scaffold(
          backgroundColor: AppColors.backGround,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildStepIndicator(),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) =>
                          setState(() => currentStep = index),
                      children: [
                        _buildHouseholdStep(),
                        _buildUserInfoStep(),
                        _buildSecurityStep(),
                      ],
                    ),
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => widget.pageController.animateToPage(
              0,
              duration: Durations.long1,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.secondaryGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.inputBg, size: 18),
                const SizedBox(width: 6),
                Text(
                  AppString.signup.tr(),
                  style: TextStyle(
                    color: AppColors.inputBg,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          _buildStepDot(0, AppString.houseStepTitle.tr()),
          _buildStepLine(0),
          _buildStepDot(1, AppString.userStepTitle.tr()),
          _buildStepLine(1),
          _buildStepDot(2, AppString.password.tr()),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(colors: AppColors.secondaryGradient)
                  : null,
              color: isActive ? null : const Color(0xFF2D3548),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.primary : const Color(0xFF2D3548),
                width: 2,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? AppColors.inputBg : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(colors: AppColors.secondaryGradient)
              : null,
          color: isActive ? null : const Color(0xFF2D3548),
        ),
      ),
    );
  }

  Widget _buildHouseholdStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            AppString.houseStepTitle.tr(),
            AppString.houseStepMsg.tr(),
            Icons.home_rounded,
          ),
          const SizedBox(height: 30),
          _buildInfoCard(AppString.houseStepInfo.tr(), const Color(0xFF4ECDC4)),
          const SizedBox(height: 25),
          MyField(
            controller: cubit.houseNameCont,
            hint: AppString.houseName.tr(),
            icon: Icons.house_rounded,
          ),
          const SizedBox(height: 20),
          MyField(
            controller: cubit.countryCont,
            hint: AppString.country.tr(),
            icon: Icons.public_rounded,
          ),
          const SizedBox(height: 20),
          MyField(
            controller: cubit.cityCont,
            hint: AppString.city,
            icon: Icons.location_city_rounded,
          ),
          const SizedBox(height: 20),
          MyField(
            controller: cubit.addressCont,
            hint: AppString.address.tr(),
            icon: Icons.location_on_rounded,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            AppString.userStepTitle.tr(),
            AppString.userStepMsg.tr(),
            Icons.person_rounded,
          ),
          const SizedBox(height: 30),
          _buildInfoCard(AppString.userStepInfo.tr(), const Color(0xFF6C63FF)),
          const SizedBox(height: 25),
          MyField(
            controller: cubit.fullNameCont,
            hint: AppString.name.tr(),
            icon: Icons.account_circle_rounded,
          ),
          const SizedBox(height: 20),
          MyField(
            controller: cubit.emailCont,
            hint: AppString.email.tr(),
            icon: Icons.email_rounded,
            keyType: TextInputType.emailAddress,
            validator: (p0) {
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(p0 ?? ""))
                return AppString.invalidFormat.tr();
              return null;
            },
          ),
          const SizedBox(height: 25),
          // _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildSecurityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle(
            AppString.password.tr(),
            AppString.passwordTitle.tr(),
            Icons.security_rounded,
          ),
          const SizedBox(height: 30),
          _buildInfoCard(AppString.passwordInfo.tr(), const Color(0xFFFFB84D)),
          const SizedBox(height: 25),
          MyField(
            onChanged: (p0) => setState(() {}),
            controller: cubit.passwordCont,
            hint: AppString.password.tr(),
            icon: Icons.lock_rounded,
            isObscure: obscurePassword,
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => obscurePassword = !obscurePassword),
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          MyField(
            onChanged: (p0) => setState(() {}),
            controller: cubit.cPasswordCont,
            hint: AppString.confirmPassword.tr(),
            icon: Icons.lock_reset_rounded,
            isObscure: obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => obscureConfirmPassword = !obscureConfirmPassword,
              ),
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 25),
          _buildPasswordStrengthIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.secondaryGradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.inputBg, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.info_outline_rounded, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildFeaturesList() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFF1E2538), Color(0xFF161B2D)],
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: const Color(0xFF2D3548)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
  //             const SizedBox(width: 10),
  //             const Text(
  //               'ما ستحصل عليه',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 18),
  //         _buildFeatureItem('مراقبة لحظية لاستهلاك الطاقة', Icons.bolt),
  //         _buildFeatureItem(
  //           'توصيات ذكية لتوفير الطاقة',
  //           Icons.lightbulb_outline,
  //         ),
  //         _buildFeatureItem('التحكم في الأجهزة عن بعد', Icons.devices),
  //         _buildFeatureItem('تحليلات وتقارير تفصيلية', Icons.analytics),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildFeatureItem(String text, IconData icon) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 15),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: AppColors.primary.withOpacity(0.15),
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Icon(icon, color: AppColors.primary, size: 18),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(color: Colors.grey[300], fontSize: 14),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPasswordStrengthIndicator() {
    final password = cubit.passwordCont.text;
    final cPassword = cubit.cPasswordCont.text;
    final strength = _calculatePasswordStrength(password);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.passwordStrength.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    gradient: index < strength
                        ? LinearGradient(colors: _getStrengthColor(strength))
                        : null,
                    color: index < strength ? null : const Color(0xFF2D3548),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 15),
          _buildPasswordRequirement(
            AppString.passwordLengthCheck.tr(),
            password.length >= 8,
          ),
          _buildPasswordRequirement(
            AppString.passwordUpperCheck.tr(),
            password.contains(RegExp(r'[A-Z]')),
          ),
          _buildPasswordRequirement(
            AppString.passwordLowerCheck.tr(),
            password.contains(RegExp(r'[a-z]')),
          ),
          _buildPasswordRequirement(
            AppString.passwordDigitsCheck.tr(),
            password.contains(RegExp(r'[0-9]')),
          ),
          _buildPasswordRequirement(
            AppString.passwordConfirmCheck.tr(),
            cPassword == password && password.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            color: met ? const Color(0xFF4ECDC4) : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: met ? Colors.white : Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password == cubit.cPasswordCont.text && password.isNotEmpty) strength++;
    return strength;
  }

  List<Color> _getStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return [const Color(0xFFFF6B6B), const Color(0xFFFF6B6B)];
      case 2:
        return [const Color(0xFFFFB84D), const Color(0xFFFFB84D)];
      case 3:
        return [const Color(0xFF4ECDC4), const Color(0xFF4ECDC4)];
      case 4:
        return [AppColors.primary, const Color(0xFF8FD63F)];
      case 5:
        return AppColors.secondaryGradient;
      default:
        return [const Color(0xFF2D3548), const Color(0xFF2D3548)];
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.primaryGradient,
        ),
        border: Border(top: BorderSide(color: const Color(0xFF2D3548))),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2D3548)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  AppString.previous.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: nextStep,
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.inputBg,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.primary,
                    ),
                  ),
              child: Text(
                currentStep == 2 ? AppString.signup.tr() : AppString.next.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.inputBg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

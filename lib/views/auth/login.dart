import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/blocs/auth_bloc/auth_cubit.dart';
import 'package:volty/blocs/auth_bloc/auth_states.dart';
import 'package:volty/components/auth/forgot_pw_dialog.dart';
import 'package:volty/components/general/my_field.dart';
import 'package:volty/components/general/my_loading_indicator.dart';
import 'package:volty/src/app_navigator.dart';
import 'package:volty/src/app_string.dart';
import 'package:volty/views/auth/splash_screen.dart';

import '../../components/general/snackbar.dart';
import '../../src/app_assets.dart';
import '../../src/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.pageController});
  final PageController pageController;

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
          AppNavigator.pop(context);
        }
      },
      builder: (context, state) {
        AuthCubit cubit = context.read<AuthCubit>();
        return Scaffold(
          backgroundColor: AppColors.backGround,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildBackButton(),
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 50),
                    _buildLoginForm(cubit),
                    const SizedBox(height: 25),
                    _buildRememberMeRow(context, cubit),
                    const SizedBox(height: 30),
                    _buildLoginButton(cubit),
                    const SizedBox(height: 20),
                    // _buildDivider(),
                    // const SizedBox(height: 20),
                    // _buildSocialLogin(),
                    // const SizedBox(height: 30),
                    _buildSignUpPrompt(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E2538), // AppColors.secondary
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF2D3548),
          ), // AppColors.border
        ),
        child: IconButton(
          onPressed: () => pageController.animateToPage(
            0,
            duration: Durations.long1,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFB8FF57),
                Color(0xFF8FD63F),
              ], // AppColors.secondaryGradient
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB8FF57).withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Image.asset(AppAssets.logo, scale: 5),
        ),
        const SizedBox(height: 25),
        Text(
          AppString.loginWelcome1.tr(),
          style: TextStyle(
            color: Colors.white, // AppColors.primaryFont
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppString.loginWelcome2.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[400], // AppColors.grey
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthCubit cubit) {
    return Form(
      key: cubit.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyField(
            controller: cubit.emailCont,
            hint: AppString.email.tr(),
            icon: Icons.email_rounded,
            keyType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          MyField(
            controller: cubit.passwordCont,
            hint: AppString.password.tr(),
            icon: Icons.lock_rounded,
            isObscure: cubit.obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                cubit.obscurePassword = !cubit.obscurePassword;
                cubit.refreshState();
              },
              icon: Icon(
                cubit.obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberMeRow(BuildContext context, AuthCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: cubit.rememberMe,
                onChanged: (value) {
                  cubit.rememberMe = value ?? false;
                  cubit.refreshState();
                },
                activeColor: const Color(0xFFB8FF57),
                checkColor: const Color(0xFF0A0E1A),
                side: const BorderSide(color: Color(0xFF2D3548)),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppString.rememberMe.tr(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        TextButton(
          onPressed: () => showForgotDialog(context, cubit),
          child: Text(
            AppString.forgot.tr(),
            style: TextStyle(
              color: Color(0xFFB8FF57),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthCubit cubit) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB8FF57), Color(0xFF8FD63F)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8FF57).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (cubit.loginFormKey.currentState!.validate()) cubit.loginUser();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          AppString.login.tr(),
          style: TextStyle(
            color: Color(0xFF0A0E1A),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.loginSignupMsg.tr(),
          style: TextStyle(color: Colors.grey[400], fontSize: 15),
        ),
        TextButton(
          onPressed: () {
            pageController.animateToPage(
              2,
              duration: Durations.long1,
              curve: Curves.fastLinearToSlowEaseIn,
            );
          },
          child: Text(
            AppString.signup.tr(),
            style: TextStyle(
              color: Color(0xFFB8FF57),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

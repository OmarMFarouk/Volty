import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volty/blocs/auth_bloc/auth_cubit.dart';
import 'package:volty/src/app_string.dart';

import '../../src/app_colors.dart';
import '../general/my_field.dart';

showForgotDialog(BuildContext context, AuthCubit cubit) {
  FocusManager.instance.primaryFocus?.unfocus();
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.key,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppString.forgot.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryFont,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppString.forgotMsg.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryFont.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              MyField(
                validator: (value) {
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value!)) {
                    return 'بريد إلكتروني غير صالح';
                  }
                  return null;
                },
                controller: cubit.emailCont,
                hint: AppString.email.tr(),
                icon: FontAwesomeIcons.envelope,
                keyType: TextInputType.emailAddress,
                maxLength: 100,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppString.cancel.tr(),
                        style: TextStyle(
                          color: AppColors.primaryFont.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          cubit.resetPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppString.okay.tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

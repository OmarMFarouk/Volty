import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/src/app_localization.dart';
import 'package:volty/src/app_navigator.dart';
import 'package:volty/src/app_secured.dart';
import 'package:volty/views/auth/index.dart';

import '../../src/app_colors.dart';
import '../../src/app_string.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.account.tr(), // Localized
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              _buildProfileHeader(),
              SizedBox(height: 25),
              _buildStatsCards(),
              SizedBox(height: 25),
              _buildSettingsSection(AppString.settings.tr(), [
                // Localized
                SettingItem(
                  AppString.profile, // Localized
                  Icons.person_outline_rounded,
                  () {},
                ),
                SettingItem(
                  AppString.notifications, // Localized
                  Icons.notifications_outlined,
                  () {},
                ),
                SettingItem(
                  AppString.smartReminders, // Localized
                  Icons.notifications_active_outlined,
                  () {},
                ),
                SettingItem(
                  AppString.language, // Localized
                  Icons.language_rounded,
                  () => _showLanguageDialog(context),
                ),
              ]),
              SizedBox(height: 20),
              // _buildSettingsSection(AppString.energyManagement, [
              //   // Localized
              //   SettingItem(
              //     AppString.autoSavingMode, // Localized
              //     Icons.eco_outlined,
              //     () {},
              //   ),
              //   SettingItem(
              //     AppString.scheduling, // Localized
              //     Icons.schedule_outlined,
              //     () {},
              //   ),
              //   SettingItem(
              //     AppString.consumptionLimits, // Localized
              //     Icons.speed_outlined,
              //     () {},
              //   ),
              //   SettingItem(
              //     AppString.solarSettings, // Localized
              //     Icons.solar_power_outlined,
              //     () {},
              //   ),
              // ]),

              // SizedBox(height: 20),
              // _buildSettingsSection(AppString.billingAndPayment, [
              //   // Localized
              //   SettingItem(
              //     AppString.paymentMethods, // Localized
              //     Icons.payment_rounded,
              //     () {},
              //   ),
              //   SettingItem(
              //     AppString.billingHistory, // Localized
              //     Icons.receipt_long_rounded,
              //     () {},
              //   ),
              //   SettingItem(
              //     AppString.subscriptions, // Localized
              //     Icons.card_membership_rounded,
              //     () {},
              //   ),
              // ]),
              // SizedBox(height: 20),
              _buildSettingsSection(AppString.helpSupport.tr(), [
                // Localized
                SettingItem(
                  AppString.helpCenter.tr(), // Localized
                  Icons.help_outline_rounded,
                  () {},
                ),
                SettingItem(
                  AppString.contactUs.tr(), // Localized
                  Icons.contact_support_outlined,
                  () {},
                ),
                SettingItem(
                  AppString.rateUs.tr(), // Localized
                  Icons.star_outline_rounded,
                  () {},
                ),
              ]),
              SizedBox(height: 25),
              _buildLogoutButton(context),
              SizedBox(height: 15),
              Center(
                child: Text(
                  '${AppString.version.tr()} 1.0.0', // Localized with version
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
              SizedBox(height: kToolbarHeight * 1.5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E2538), Color(0xFF161B2D)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Color(0xFF2D3548)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFF8FD63F)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                AppGlobals.currentUser!.initials,
                style: TextStyle(
                  color: Color(0xFF0A0E1A),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppGlobals.currentUser!.name!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  AppGlobals.currentUser!.email!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        AppString.verifiedAccount.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1E2538),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF2D3548)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                SizedBox(height: 12),
                Text(
                  "${AppGlobals.currentUser!.daysSince ?? "0"}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppString.daysWithUs.tr(), // Localized
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1E2538),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF2D3548)),
            ),
            child: Column(
              children: [
                Icon(Icons.eco_rounded, color: Color(0xFF4ECDC4), size: 28),
                SizedBox(height: 12),
                Text(
                  '1.2 ${AppString.ton.tr()}', // Localized with unit
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppString.co2Savings.tr(), // Localized
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<SettingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFF2D3548)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildSettingItem(item),
                  if (index < items.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(color: Color(0xFF2D3548), height: 1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(SettingItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.grey[400], size: 24),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                item.title.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6B6B).withOpacity(0.2),
            Color(0xFFFF8E53).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFF6B6B).withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () async {
          await AppSecured.clear();
          AppNavigator.pushR(
            context,
            AuthIndex(),
            NavigatorAnimation.fadeAnimation,
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFFF6B6B), size: 24),
              SizedBox(width: 12),
              Text(
                AppString.logout.tr(), // Localized
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF1E2538),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalization.isArabic(context)
                ? "اختر اللغة"
                : "Select Language",
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: DropdownButtonFormField(
              value: AppLocalization.isArabic(context) ? "عربي" : "English",
              decoration: InputDecoration(
                labelText: AppString.language.tr(),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF2D3548)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              dropdownColor: Color(0xFF1E2538),
              style: TextStyle(color: Colors.white),
              items: ['عربي', 'English'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Text(type == 'عربي' ? "🇪🇬" : "🇺🇸"),
                      SizedBox(width: 10),
                      Text(type),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setDialogState(() {
                  AppLocalization.setLocale(
                    value == 'عربي' ? Locale('ar', "EG") : Locale('en', "US"),
                    context,
                  );
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppString.cancel.tr(),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SettingItem(this.title, this.icon, this.onTap);
}

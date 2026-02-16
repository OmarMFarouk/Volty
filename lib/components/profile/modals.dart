import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volty/src/app_assets.dart';
import 'package:volty/src/app_colors.dart';
import 'package:volty/src/app_endpoints.dart';
import 'package:volty/src/app_string.dart';

class ProfileModalsHelper {
  /// Show Help Center modal with options
  static void showHelpCenterModal(BuildContext context) {
    _showCustomModal(
      context: context,
      title: AppString.helpCenter.tr(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModalItem(
            context: context,
            icon: Icons.help_outline_rounded,
            title: AppString.faq.tr(),
            subtitle: AppString.faqTitle.tr(),
            onTap: () {
              Navigator.pop(context);
              showFAQModal(context);
            },
          ),
          _buildDivider(),
          _buildModalItem(
            context: context,
            icon: Icons.info_outline_rounded,
            title: AppString.aboutUs.tr(),
            subtitle: AppString.learnMoreAbout.tr(),
            onTap: () {
              Navigator.pop(context);
              showAboutUsModal(context);
            },
          ),
          _buildDivider(),
          _buildModalItem(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: AppString.privacyPolicy.tr(),
            subtitle: AppString.privacyPolicySubtitle.tr(),
            onTap: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse(AppEndPoints.privacy),
                mode: LaunchMode.externalApplication,
              );
            },
          ),

          _buildDivider(),
          _buildModalItem(
            context: context,
            icon: Icons.description_outlined,
            title: AppString.termsOfService.tr(),
            subtitle: AppString.termsOfServiceSubtitle.tr(),
            onTap: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse(AppEndPoints.terms),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          _buildDivider(),
          _buildModalItem(
            context: context,
            icon: Icons.no_accounts_outlined,
            title: AppString.deleteAccount.tr(),
            subtitle: AppString.deleteAccountSubtitle.tr(),
            onTap: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse(AppEndPoints.delete),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Show Contact Us modal with contact information
  static void showContactUsModal(BuildContext context) {
    _showCustomModal(
      context: context,
      title: AppString.contactUs.tr(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildContactItem(
            context: context,
            icon: Icons.language_rounded,
            title: AppString.website.tr(),
            value: "volty.barmajha.com",
            onTap: () {
              launchUrl(
                Uri.parse(AppEndPoints.website),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          _buildDivider(),
          _buildContactItem(
            context: context,
            icon: Icons.email_outlined,
            title: AppString.email.tr(),
            value: "contact@barmajha.com",
            onTap: () {
              launchUrl(
                Uri.parse('mailto:contact@barmajha.com'),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
          _buildDivider(),
          _buildContactItem(
            context: context,
            icon: FontAwesomeIcons.whatsapp,
            title: AppString.phone.tr(),
            value: "+20 127 066 1064",
            onTap: () {
              Uri.parse('https://wa.me/+201270661064');
            },
          ),
          _buildDivider(),
          _buildContactItem(
            context: context,
            icon: Icons.support_agent_rounded,
            title: AppString.support.tr(),
            value: AppString.support24.tr(),
            iconColor: AppColors.primary,
            onTap: null,
          ),
        ],
      ),
    );
  }

  /// Show About Us modal
  static void showAboutUsModal(BuildContext context) {
    _showCustomScrollableModal(
      context: context,
      title: AppString.aboutUsTitle.tr(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/Icon placeholder
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF8FD63F)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(AppAssets.logo, width: 60, height: 60),
                ),
              ),
            ),
            SizedBox(height: 25),

            // Title
            Center(
              child: Text(
                AppString.aboutVoltyTitle.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                AppString.aboutVoltySubtitle.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 25),

            // Description
            Text(
              AppString.aboutVoltyDesc.tr(),
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 15,
                height: 1.6,
              ),
            ),

            SizedBox(height: 25),

            // Stats
            _buildStatsRow(context),
            SizedBox(height: 25),

            // Key Features Section
            _buildSectionTitle(AppString.keyFeatures.tr()),
            SizedBox(height: 15),
            _buildFeatureItem(
              AppString.realtimeMonitoring.tr(),
              Icons.show_chart,
            ),
            _buildFeatureItem(
              AppString.smartDeviceControl.tr(),
              Icons.devices_rounded,
            ),
            _buildFeatureItem(
              AppString.detailedAnalytics.tr(),
              Icons.analytics_outlined,
            ),
            _buildFeatureItem(
              AppString.egyptianTierCalc.tr(),
              Icons.calculate_outlined,
            ),
            _buildFeatureItem(
              AppString.aiRecommendations.tr(),
              Icons.psychology_outlined,
            ),
            _buildFeatureItem(
              AppString.solarIntegration.tr(),
              Icons.solar_power_outlined,
            ),
            _buildFeatureItem(
              AppString.smartScheduling.tr(),
              Icons.schedule_outlined,
            ),
            _buildFeatureItem(
              AppString.instantAlerts.tr(),
              Icons.notifications_active_outlined,
            ),

            SizedBox(height: 25),

            // Company Info
            _buildSectionTitle(AppString.developedBy.tr()),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF161B2D),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xFF2D3548)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Barmajha - برمجها",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppString.companyDescription.tr(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey[500],
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        AppString.locationValue.tr(),
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Version
            Center(
              child: Text(
                "${AppString.version.tr()} 1.0.0",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                AppString.copyright.tr(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show FAQ modal
  static void showFAQModal(BuildContext context) {
    _showCustomScrollableModal(
      context: context,
      title: AppString.faqTitle.tr(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQItem(
              question: AppString.faqQ1.tr(),
              answer: AppString.faqA1.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ2.tr(),
              answer: AppString.faqA2.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ3.tr(),
              answer: AppString.faqA3.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ4.tr(),
              answer: AppString.faqA4.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ5.tr(),
              answer: AppString.faqA5.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ6.tr(),
              answer: AppString.faqA6.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ7.tr(),
              answer: AppString.faqA7.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ8.tr(),
              answer: AppString.faqA8.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ9.tr(),
              answer: AppString.faqA9.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ10.tr(),
              answer: AppString.faqA10.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ11.tr(),
              answer: AppString.faqA11.tr(),
            ),
            _buildFAQItem(
              question: AppString.faqQ12.tr(),
              answer: AppString.faqA12.tr(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build FAQ items
  static Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color(0xFF161B2D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF2D3548)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build section titles
  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Helper method to build feature items
  static Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build stats row
  static Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem("500+", AppString.egyptianHomes.tr()),
        _buildStatItem("35%", AppString.avgSavings.tr()),
        _buildStatItem("24/7", AppString.monitoring247.tr()),
      ],
    );
  }

  static Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Base modal widget
  static void _showCustomModal({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E2538),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Color(0xFF2D3548)),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E2538), Color(0xFF161B2D)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: Colors.grey[400]),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Content
              Container(padding: EdgeInsets.all(20), child: child),
            ],
          ),
        ),
      ),
    );
  }

  // Scrollable modal widget for longer content
  static void _showCustomScrollableModal({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0xFF1E2538),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Color(0xFF2D3548)),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E2538), Color(0xFF161B2D)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: Colors.grey[400]),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Scrollable Content
              Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      ),
    );
  }

  // Modal item widget
  static Widget _buildModalItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 22),
          ],
        ),
      ),
    );
  }

  // Contact item widget
  static Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  SizedBox(height: 3),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 22),
          ],
        ),
      ),
    );
  }

  // Divider widget
  static Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Divider(color: Color(0xFF2D3548), height: 1),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/src/app_navigator.dart';
import 'package:volty/src/app_secured.dart';
import 'package:volty/views/auth/index.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الحساب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              _buildProfileHeader(),
              const SizedBox(height: 25),
              _buildStatsCards(),
              const SizedBox(height: 25),
              _buildSettingsSection('الإعدادات العامة', [
                SettingItem(
                  'الملف الشخصي',
                  Icons.person_outline_rounded,
                  () {},
                ),
                SettingItem('الإشعارات', Icons.notifications_outlined, () {}),
                SettingItem(
                  'التنبيهات الذكية',
                  Icons.notifications_active_outlined,
                  () {},
                ),
                SettingItem('اللغة', Icons.language_rounded, () {}),
              ]),
              const SizedBox(height: 20),
              _buildSettingsSection('إدارة الطاقة', [
                SettingItem('وضع التوفير التلقائي', Icons.eco_outlined, () {}),
                SettingItem('الجدولة الزمنية', Icons.schedule_outlined, () {}),
                SettingItem('حدود الاستهلاك', Icons.speed_outlined, () {}),
                SettingItem(
                  'إعدادات الطاقة الشمسية',
                  Icons.solar_power_outlined,
                  () {},
                ),
              ]),
              const SizedBox(height: 20),
              _buildSettingsSection('الفوترة والدفع', [
                SettingItem('طرق الدفع', Icons.payment_rounded, () {}),
                SettingItem('سجل الفواتير', Icons.receipt_long_rounded, () {}),
                SettingItem('الاشتراكات', Icons.card_membership_rounded, () {}),
              ]),
              const SizedBox(height: 20),
              _buildSettingsSection('الدعم والمساعدة', [
                SettingItem('مركز المساعدة', Icons.help_outline_rounded, () {}),
                SettingItem(
                  'تواصل معنا',
                  Icons.contact_support_outlined,
                  () {},
                ),
                SettingItem('تقييم التطبيق', Icons.star_outline_rounded, () {}),
              ]),
              const SizedBox(height: 25),
              _buildLogoutButton(context),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  'النسخة 1.0.0',
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
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1E2538), const Color(0xFF161B2D)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFB8FF57), const Color(0xFF8FD63F)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB8FF57).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                AppGlobals.currentUser!.initials,
                style: TextStyle(
                  color: const Color(0xFF0A0E1A),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
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
                const SizedBox(height: 6),
                Text(
                  AppGlobals.currentUser!.email!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8FF57).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFB8FF57).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: const Color(0xFFB8FF57),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'حساب موثق',
                        style: TextStyle(
                          color: const Color(0xFFB8FF57),
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2538),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D3548)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: const Color(0xFFB8FF57),
                  size: 28,
                ),
                const SizedBox(height: 12),
                Text(
                  "${AppGlobals.currentUser!.daysSince ?? "N/A"}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'يوم معنا',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2538),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D3548)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.eco_rounded,
                  color: const Color(0xFF4ECDC4),
                  size: 28,
                ),
                const SizedBox(height: 12),
                Text(
                  '1.2 طن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'توفير CO₂',
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
          padding: const EdgeInsets.only(right: 5, bottom: 12),
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
            color: const Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2D3548)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(color: const Color(0xFF2D3548), height: 1),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.grey[400], size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                item.title,
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
            const Color(0xFFFF6B6B).withOpacity(0.2),
            const Color(0xFFFF8E53).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3)),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: const Color(0xFFFF6B6B),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: const Color(0xFFFF6B6B),
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
}

class SettingItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SettingItem(this.title, this.icon, this.onTap);
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volty/blocs/dash_bloc/dash_cubit.dart';
import 'package:volty/components/general/my_toast.dart';
import 'package:volty/components/general/refresh.dart';
import 'package:volty/components/general/snackbar.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/views/main/index.dart';
import '../../blocs/dash_bloc/dash_states.dart';
import '../../blocs/devices_bloc/cubit.dart';
import '../../components/dashboard/metrics_card.dart';
import '../../components/dashboard/welcome_header.dart';
import '../../components/general/error_widget.dart';

import '../../components/dashboard/energy_meter.dart';
import '../../models/device_model.dart';
import '../../services/web_helper.dart';
import '../../src/app_colors.dart';
import '../../src/app_string.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomRefresh(
      onRefresh: () async => await context.read<DashCubit>().fetchDashboard(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<DashCubit, DashStates>(
            listener: (context, state) {
              if (state is DashError) {
                MySnackBar.show(
                  context: context,
                  text: state.msg,
                  isAlert: true,
                );
              }
              if (state is DashSuccess) {
                MySnackBar.show(
                  context: context,
                  text: state.msg,
                  isAlert: false,
                );
              }
              if (state is DashRefresh) {
                MyToast.show(context, state.msg);
                ReloadHelper.reloadPage();
              }
            },
            builder: (context, state) {
              return Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeHeader(),
                  EnergyCard(),
                  // BalanceCard(),
                  MetricsCard(),
                  if (AppGlobals.analyticsModel?.peakUsage?.isNotEmpty ?? false)
                    WarningWidget(),
                  // ActionsCard(),
                  // AiCard(),
                  if (AppGlobals.devicesModel?.devicesCount != 0)
                    _buildActiveDevicesPreview(context),
                  // _buildEnergySourcesCard(),
                  _buildWeeklyConsumption(),
                  SizedBox(height: kToolbarHeight * 1.5),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActiveDevicesPreview(BuildContext context) {
    List<Device?> devices =
        AppGlobals.devicesModel?.rooms
            ?.expand((d) => d?.devices ?? <Device>[])
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppString.activeDevices.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => mainPageController.animateToPage(
                1,
                duration: Durations.medium2,
                curve: Curves.fastLinearToSlowEaseIn,
              ),
              icon: Text(
                AppString.showAll.tr(),
                style: TextStyle(color: AppColors.primary),
              ),
              label: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...List.generate(
          devices.take(5).length,
          (r) => _buildDevicePreviewCard(
            context,
            devices[r]!,
            Icons.ac_unit_rounded,
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildDevicePreviewCard(
    BuildContext context,
    Device device,
    IconData icon,
    bool isOn,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: device.isOn
              ? AppColors.primary.withOpacity(0.3)
              : const Color(0xFF2D3548),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: device.isOn
                  ? AppColors.primary.withOpacity(0.15)
                  : const Color(0xFF2D3548),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: device.isOn ? AppColors.primary : Colors.grey,
              size: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.bolt, color: Colors.grey[400], size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${(device.totalConsumption! / 1000).toStringAsFixed(2)} ${AppString.unitK.tr()}",
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(width: 15),
                    if (device.deviceLoad.isFinite)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getPercentageColor(
                            device.deviceLoad,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${device.deviceLoad}%',
                          style: TextStyle(
                            color: _getPercentageColor(device.deviceLoad),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: device.isOn,
            onChanged: (value) async {
              device.state = value == true ? "off" : "on";
              context.read<DashCubit>().refreshState();
              await context.read<DevicesCubit>().toggleDevice(
                deviceId: device.id!,
              );
            },
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return const Color(0xFFFF6B6B);
    if (percentage >= 50) return const Color(0xFFFFB84D);
    return const Color(0xFF4ECDC4);
  }

  Widget _buildWeeklyConsumption() {
    final weeklyData = AppGlobals.dashModel?.weeklyConsumption;
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF2D3548)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 3,
                  children: [
                    Text(
                      AppString.weeklyConsumption.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppString.unitK.tr(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Icon(
                    (weeklyData!.isIncrease ?? false)
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: (weeklyData.isIncrease ?? false)
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF4CAF50),
                    size: 16,
                  ),
                  Text(
                    ' ${(weeklyData.percentageChange ?? 0).abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: (weeklyData.isIncrease ?? false)
                          ? const Color(0xFFFF6B6B)
                          : const Color(0xFF4CAF50),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 1),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyData.weeklyData!.map((dayData) {
                return _buildChartBar(
                  dayData.day ?? '',
                  dayData.normalizedValue ?? 0,
                  (dayData.consumption ?? 0) / 1000,
                  dayData.isToday ?? false,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double value, double kwh, bool isActive) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isActive && kwh > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  kwh.toStringAsFixed(1),
                  style: TextStyle(
                    color: const Color(0xFF0A0E1A),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isActive && kwh > 0) const SizedBox(height: 6),
            Container(
              height: (value > 0
                  ? (value.clamp(6.5, 20))
                  : 0.1), // Minimum height for visibility
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isActive && kwh > 0
                      ? [AppColors.primary, const Color(0xFF8FD63F)]
                      : [const Color(0xFF2D3548), const Color(0xFF1E2538)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: isActive && kwh > 0
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              getLocalizedDay(day).substring(0, 3),
              style: TextStyle(
                color: isActive ? AppColors.primary : Colors.grey[400],
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getLocalizedDay(String day) {
    switch (day) {
      case 'إثن':
        return AppString.monday.tr();
      case 'ثلا':
        return AppString.tuesday.tr();
      case 'أرب':
        return AppString.wednesday.tr();
      case 'خمي':
        return AppString.thursday.tr();
      case 'جمع':
        return AppString.friday.tr();
      case 'سبت':
        return AppString.saturday.tr();
      case 'أحد':
        return AppString.sunday.tr();
      default:
        return day;
    }
  }
}

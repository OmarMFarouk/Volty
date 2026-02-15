import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_string.dart';

import '../../src/app_globals.dart';

class MetricsCard extends StatelessWidget {
  const MetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            "${AppString.rooms.tr()} ${AppString.active.tr()}",
            AppGlobals.devicesModel!.activeRoomsCount.toString(),
            "${AppString.out.tr()} ${AppGlobals.devicesModel!.roomsCount}",
            Icons.trending_down_rounded,
            const Color(0xFF4ECDC4),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildMetricCard(
            AppString.activeDevices.tr(),
            AppGlobals.devicesModel?.activeCount.toString() ?? "0",
            "${AppString.out.tr()} ${AppGlobals.devicesModel!.devicesCount}",
            Icons.power_rounded,
            const Color(0xFFFF6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
}

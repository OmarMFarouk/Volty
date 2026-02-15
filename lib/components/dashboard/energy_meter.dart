import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_globals.dart';
import 'package:volty/src/app_string.dart';
import '../../src/app_colors.dart';
import 'meter_paint.dart';

class EnergyCard extends StatefulWidget {
  const EnergyCard({super.key});

  @override
  State<EnergyCard> createState() => _EnergyCardState();
}

class _EnergyCardState extends State<EnergyCard> {
  // Clamp progress to max 100%
  double progress = (AppGlobals.dashModel!.loadPercentage! / 100).clamp(
    0.0,
    1.0,
  );
  double progressing = 0;

  @override
  void initState() {
    super.initState();
    _animateProgress();
  }

  void _animateProgress() {
    // Calculate increment based on target value for smoother animation
    final double increment = progress > 0.5 ? 0.02 : 0.01;

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 5));
      setState(() {
        if (progressing < progress) {
          progressing = math.min(progressing + increment, progress);
        } else {
          progressing = progress;
        }
      });
      return progressing < progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1E2538), const Color(0xFF161B2D)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF2D3548)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.realTimeMeter.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${AppString.continuousUpdate.tr()} - (${AppString.unitK.tr()})",
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(
                      AppGlobals.dashModel!.loadPercentage! > 0 ? 0.3 : 0.1,
                    ),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(
                          AppGlobals.dashModel!.loadPercentage! > 0 ? 1 : 0.3,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(
                              AppGlobals.dashModel!.loadPercentage! > 0
                                  ? 0.5
                                  : 0,
                            ),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppString.active.tr(),
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(
                          AppGlobals.dashModel!.loadPercentage! > 0 ? 1 : 0.3,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomPaint(
            size: const Size(200, 180),
            painter: EnergyMeterPainter(
              progress: progressing,
              hintText: AppString.fromMax.tr(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E1A).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D3548)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMeterInfo(
                    AppString.liveConsumption.tr(),
                    ((AppGlobals.dashModel!.currentWHRate ?? 0) / 1000)
                        .toStringAsFixed(2),
                    Icons.bolt,
                    AppColors.primary,
                  ),
                ),
                Container(width: 1, height: 40, color: const Color(0xFF2D3548)),
                Expanded(
                  child: _buildMeterInfo(
                    AppString.today.tr(),
                    ((AppGlobals.dashModel!.todayWHConsumption ?? 0) / 1000)
                        .toStringAsFixed(2),
                    Icons.today,
                    const Color(0xFF4ECDC4),
                  ),
                ),
                Container(width: 1, height: 40, color: const Color(0xFF2D3548)),
                Expanded(
                  child: _buildMeterInfo(
                    AppString.peak.tr(),
                    ((AppGlobals.dashModel!.todakWHPeak ?? 0) / 1000)
                        .toStringAsFixed(2),
                    Icons.trending_up,
                    const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeterInfo(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

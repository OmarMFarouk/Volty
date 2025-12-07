import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:volty/src/app_globals.dart';
import '../../src/app_colors.dart';

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
            color: const Color(0xFFB8FF57).withOpacity(0.1),
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
                    'عداد الطاقة اللحظي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'تحديث مستمر',
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
                      'نشط',
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
            painter: EnergyMeterPainter(progress: progressing),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E1A).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D3548)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMeterInfo(
                  'الاستهلاك الآن',
                  '${AppGlobals.dashModel!.currentKwhRate?.toStringAsFixed(2) ?? 0} ك.و',
                  Icons.bolt,
                  const Color(0xFFB8FF57),
                ),
                Container(width: 1, height: 40, color: const Color(0xFF2D3548)),
                _buildMeterInfo(
                  'اليوم',
                  '${AppGlobals.dashModel!.todayKwhConsumption?.toStringAsFixed(2) ?? 0} ك.و',
                  Icons.today,
                  const Color(0xFF4ECDC4),
                ),
                Container(width: 1, height: 40, color: const Color(0xFF2D3548)),
                _buildMeterInfo(
                  'الذروة',
                  '${AppGlobals.dashModel!.todakKwhPeak?.toStringAsFixed(2) ?? 0} ك.و',
                  Icons.trending_up,
                  const Color(0xFFFF6B6B),
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

class EnergyMeterPainter extends CustomPainter {
  final double progress;

  EnergyMeterPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 25;

    // Clamp progress to 0-1 range
    final clampedProgress = progress.clamp(0.0, 1.0);

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFF2D3548)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc with gradient
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: clampedProgress > 0.8
            ? [
                AppColors.red.withOpacity(0.6),
                AppColors.red,
                AppColors.red.withOpacity(0.6),
              ]
            : [
                const Color(0xFFB8FF57).withOpacity(0.6),
                const Color(0xFF8FD63F),
                const Color(0xFFB8FF57).withOpacity(0.6),
              ],
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * clampedProgress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Center text - Convert to percentage (0-100)
    final percentageValue = (clampedProgress * 100).clamp(0.0, 100.0);

    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: percentageValue >= 10
                ? percentageValue.toStringAsFixed(0)
                : percentageValue.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontSize: 33,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '%',
            style: TextStyle(
              color: const Color(0xFFB8FF57),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 - 10,
      ),
    );

    // Subtitle
    final subtitlePainter = TextPainter(
      text: TextSpan(
        text: 'من الحد الأقصى',
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      ),
      textDirection: TextDirection.rtl,
    );

    subtitlePainter.layout();
    subtitlePainter.paint(
      canvas,
      Offset(center.dx - subtitlePainter.width / 2, center.dy + 25),
    );

    // Animated glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFB8FF57).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant EnergyMeterPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../src/app_colors.dart';

class EnergyMeterPainter extends CustomPainter {
  final double progress;
  final String hintText;

  EnergyMeterPainter({required this.progress, required this.hintText});

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
                AppColors.primary.withOpacity(0.6),
                const Color(0xFF8FD63F),
                AppColors.primary.withOpacity(0.6),
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
              color: AppColors.primary,
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
        text: hintText,
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
      ..color = AppColors.primary.withOpacity(0.3)
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

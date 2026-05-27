// lib/widgets/bmi_gauge.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

class BmiGauge extends StatelessWidget {
  final double bmi;

  const BmiGauge({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: CustomPaint(
        size: const Size(double.infinity, 140),
        painter: _GaugePainter(bmi: bmi),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    color: AppTheme.bmiColor(bmi),
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'BMI',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double bmi;

  _GaugePainter({required this.bmi});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.85;
    final radius = size.width * 0.4;
    const strokeW = 14.0;

    // Ranges: underweight 0-18.5, normal 18.5-24, overweight 24-27,
    //         obese1 27-30, obese2 30-35, obese3 35+
    // Map to arc: from π to 0 (180°)
    const startAngle = pi;
    const sweepAngle = pi;

    final segments = [
      (AppTheme.underweight, 0.0, 18.5),
      (AppTheme.normal, 18.5, 24.0),
      (AppTheme.overweight, 24.0, 27.0),
      (AppTheme.obese1, 27.0, 30.0),
      (AppTheme.obese2, 30.0, 35.0),
      (AppTheme.obese3, 35.0, 42.0),
    ];

    const totalRange = 42.0 - 0.0;

    final bgPaint = Paint()
      ..color = AppTheme.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    for (final seg in segments) {
      final color = seg.$1;
      final from = seg.$2;
      final to = seg.$3;
      final segStart = startAngle + (from / totalRange) * sweepAngle;
      final segSweep = ((to - from) / totalRange) * sweepAngle;

      final paint = Paint()
        ..color = color.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        segStart,
        segSweep,
        false,
        paint,
      );
    }

    // Active fill up to bmi
    final clampedBmi = bmi.clamp(0.0, 42.0);
    final activeSweep = (clampedBmi / totalRange) * sweepAngle;

    for (final seg in segments) {
      final color = seg.$1;
      final from = seg.$2;
      final to = seg.$3;
      if (from >= clampedBmi) continue;

      final effectiveTo = to < clampedBmi ? to : clampedBmi;
      final segStart = startAngle + (from / totalRange) * sweepAngle;
      final segSweep = ((effectiveTo - from) / totalRange) * sweepAngle;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        segStart,
        segSweep,
        false,
        paint,
      );
    }

    // Needle
    final needleAngle = startAngle + (clampedBmi / totalRange) * sweepAngle;
    final needleLen = radius - strokeW / 2 - 4;
    final nx = cx + needleLen * cos(needleAngle);
    final ny = cy + needleLen * sin(needleAngle);

    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy), Offset(nx, ny), needlePaint);

    // Center dot
    canvas.drawCircle(
        Offset(cx, cy), 6, Paint()..color = Colors.white);
    canvas.drawCircle(
        Offset(cx, cy), 3, Paint()..color = AppTheme.cardBg);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.bmi != bmi;
}

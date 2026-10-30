import 'dart:math';

import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

class CreditScoreWidget extends StatelessWidget {
  final int score;
  final double size;

  const CreditScoreWidget({
    super.key,
    required this.score,
    this.size = 160,
  });

  Color get _scoreColor {
    if (score < 600) return AppColors.error;
    if (score < 750) return AppColors.accent;
    return AppColors.secondary;
  }

  String get _scoreLabel {
    if (score < 600) return 'Poor';
    if (score < 700) return 'Fair';
    if (score < 750) return 'Good';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (score / 900).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CreditScoreArcPainter(
          progress: progress,
          color: _scoreColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score > 0 ? '$score' : '--',
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                score > 0 ? _scoreLabel : 'N/A',
                style: TextStyle(
                  fontSize: size * 0.09,
                  fontWeight: FontWeight.w500,
                  color: _scoreColor,
                ),
              ),
              Text(
                'out of 900',
                style: TextStyle(
                  fontSize: size * 0.07,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditScoreArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CreditScoreArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) / 2) - 10;
    const startAngle = 135 * (pi / 180);
    const sweepTotal = 270 * (pi / 180);

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      bgPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CreditScoreArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

import 'package:flutter/material.dart';

class GaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;

  GaugePainter({required this.value, required this.min, required this.max});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = size.width * 0.45;

    // Draw Background Arc
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1565C0).withOpacity(0.3);

    const startAngle = 3.14159; // 180 degrees (Left)
    const sweepAngle = 3.14159; // 180 degrees (Semicircle)

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Draw Value Arc
    final valuePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF64FFDA);

    // Calculate percentage
    final percentage = (value - min) / (max - min);
    final valueSweep = sweepAngle * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      valueSweep,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

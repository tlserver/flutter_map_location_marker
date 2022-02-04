import 'dart:math' as Math;

import 'package:flutter/material.dart';

class HeadingSector extends CustomPainter {
  final Color color;
  final double heading;
  final double accuracy;

  HeadingSector(this.color, this.heading, this.accuracy);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    canvas.drawArc(
      rect,
      Math.pi * 3 / 2 + heading - accuracy,
      accuracy * 2,
      true,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(color.opacity * 1.0),
            color.withOpacity(color.opacity * 0.6),
            color.withOpacity(color.opacity * 0.3),
            color.withOpacity(color.opacity * 0.1),
            color.withOpacity(color.opacity * 0.0),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(HeadingSector oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.heading != heading ||
        oldDelegate.accuracy != accuracy;
  }
}

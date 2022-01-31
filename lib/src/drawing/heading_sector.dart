import 'dart:math' as Math;

import 'package:flutter/material.dart';

class HeadingSector extends CustomPainter {
  final Color color;

  HeadingSector(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    canvas.drawArc(
      rect,
      Math.pi * 6 / 5,
      Math.pi * 3 / 5,
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
    return oldDelegate.color == color;
  }
}

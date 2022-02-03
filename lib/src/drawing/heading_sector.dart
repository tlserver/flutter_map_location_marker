import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws the heading of the device
class HeadingSector extends CustomPainter {
  /// [CustomPainter] that draws the heading of the device
  HeadingSector(this.color, this.heading, this.accuracy);

  /// The color of the heading
  final Color color;

  /// Where the heading is pointing
  final double heading;

  /// The accuracy of the position
  final double accuracy;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    canvas.drawArc(
      rect,
      math.pi * 3 / 2 + heading - accuracy,
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
    return oldDelegate.color == color;
  }
}

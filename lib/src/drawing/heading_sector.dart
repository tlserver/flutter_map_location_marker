import 'dart:math';

import 'package:flutter/material.dart';

import '../data.dart';

/// A [CustomPainter] that draws a sector for displaying the device's heading.
class HeadingSector extends CustomPainter {
  /// The color of this sector origin. The actual color is multiplied by a
  /// opacity factor which decreases when the distance to the origin increases.
  final Color color;

  /// The heading, in radius, which define the direction of the middle point of
  /// this sector. See [LocationMarkerHeading.heading].
  final double heading;

  /// The accuracy, in radius, which affect the length of this sector. The
  /// actual length of this sector is `accuracy * 2`. See
  /// [LocationMarkerHeading.accuracy].
  final double accuracy;

  /// Create a HeadingSector.
  HeadingSector(this.color, this.heading, this.accuracy);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    canvas.drawArc(
      rect,
      pi * 3 / 2 + heading - accuracy,
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

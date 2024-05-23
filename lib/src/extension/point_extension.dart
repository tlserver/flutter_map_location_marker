import 'dart:math';

/// point extension

extension DoublePointExtension on Point<double> {
  /// Create a new [Point] where [x] and [y] values are scaled by the respective
  /// values in [other].
  Point<double> scaleBy(Point<double> other) =>
      Point<double>(x * other.x, y * other.y);
}

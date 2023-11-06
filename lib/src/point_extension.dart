import 'dart:math';

/// extension methods for [Point].
extension PointExtension<T extends num> on Point<T> {
  /// Create a new [Point] where [x] and [y] values are scaled by the respective
  /// values in [other].
  Point<T> scaleBy(Point<T> other) {
    return Point<T>(x * other.x as T, y * other.y as T);
  }
}

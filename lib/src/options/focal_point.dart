import 'dart:math';

const _originPoint = Point<double>(0, 0);

/// The [FocalPoint] class defines a screen point to align a marker on the map
/// during a focus event. It uses a combination of a normalized coordinate ratio
/// and a pixel offset to determine the marker's final position on the map
/// widget.
class FocalPoint {
  /// The normalized coordinate [ratio] for aligning the marker within the map
  /// widget. This point follows a normalized coordinate system where:
  /// - (-1.0, -1.0) aligns the marker with the top-left corner of the map
  ///   widget.
  /// - (1.0, 1.0) aligns the marker with the bottom-right corner of the map
  ///   widget.
  /// - (0.0, 0.0) aligns the marker with the center of the map widget.
  ///
  /// The ratio is used to scale the marker's position proportionally to the
  /// size of the map widget, allowing for responsive design across different
  /// screen sizes.
  final Point<double> ratio;

  /// The pixel-based [offset] is applied after the [ratio] calculation to
  /// fine-tune the marker's position. This allows for precise adjustments to
  /// the marker's screen location, accommodating for elements such as map
  /// controls or overlays that may otherwise obscure the marker.
  ///
  /// For example, an offset of (10, 20) pixels would move the marker 10 pixels
  /// to the right and 20 pixels downward from the position calculated with the
  /// [ratio].
  final Point<double> offset;

  /// Constructs a [FocalPoint] with an optional [ratio] and [offset], both
  /// defaulting to the origin point if not provided.
  const FocalPoint({
    this.ratio = _originPoint,
    this.offset = _originPoint,
  });

  /// Projects the [FocalPoint] onto the map widget given its [size]. The
  /// resulting [Point] represents the absolute pixel coordinates on the map
  /// widget where the marker should be aligned.
  Point<double> project(Point<double> size) =>
      Point<double>(
          size.x * ratio.x / 2 + offset.x,
          size.y * ratio.y / 2 + offset.y,
      );
}

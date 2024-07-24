import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

import '../drawings/default_location_marker.dart';
import 'marker_direction.dart';

/// An immutable style describing how to format and paint the location marker.
@immutable
class LocationMarkerStyle {
  /// The main marker widget. Default to [DefaultLocationMarker]
  final Widget marker;

  /// The size of main marker widget. Default to 20px * 20px.
  final Size markerSize;

  /// The alignment of the marker widget. Default to [Alignment.center]. The
  /// value is passed into [Marker.alignment] internally.
  final Alignment markerAlignment;

  /// The direction of the marker while map is rotated. Default to
  /// [MarkerDirection.top].
  final MarkerDirection markerDirection;

  /// Whether to show accuracy circle. Android define accuracy as the radius of
  /// 68% confidence so there is a 68% probability that the true location is
  /// inside the circle. Default to true.
  final bool showAccuracyCircle;

  /// The color of the accuracy circle. Default to ARGB(0x182196F3).
  final Color accuracyCircleColor;

  /// Whether to show the heading sector. Default to true.
  final bool showHeadingSector;

  /// The radius of the heading sector in pixels. Default to 60.
  final double headingSectorRadius;

  /// The color of the heading sector. Default to ARGB(0xCC2196F3).
  final Color headingSectorColor;

  /// Create a LocationMarkerStyle.
  const LocationMarkerStyle({
    this.marker = const DefaultLocationMarker(),
    this.markerSize = const Size.square(20),
    this.markerAlignment = Alignment.center,
    this.markerDirection = MarkerDirection.top,
    this.showAccuracyCircle = true,
    this.accuracyCircleColor = const Color(0x182196F3),
    this.showHeadingSector = true,
    this.headingSectorRadius = 60,
    this.headingSectorColor = const Color(0xCC2196F3),
  });
}

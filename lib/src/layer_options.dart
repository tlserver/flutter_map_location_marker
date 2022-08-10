import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'data.dart';
import 'data_stream_factory.dart';
import 'drawing/default_location_marker.dart';
import 'marker_direction.dart';

/// Describes the needed properties to create a location marker layer. Location
/// marker layer is a compose layer, containing 3 widgets which are
/// 1) an accuracy circle (in a circle layer)
/// 2) a heading sector (in a marker layer) and
/// 3) a marker (in the same marker layer).
class LocationMarkerLayerOptions {
  /// A Stream that provide position data for this marker. Default to
  /// [LocationMarkerDataStreamFactory.geolocatorPositionStream].
  final Stream<LocationMarkerPosition> positionStream;

  /// A Stream that provide heading data for this marker. Default to
  /// [LocationMarkerDataStreamFactory.compassHeadingStream].
  final Stream<LocationMarkerHeading> headingStream;

  /// The main marker widget. Default to [DefaultLocationMarker]
  final Widget marker;

  /// The size of main marker widget. Default to 20px * 20px.
  final Size markerSize;

  /// The direction of the marker. Default to [MarkerDirection.top].
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

  /// The duration of the marker's move animation. Default to 200ms.
  final Duration moveAnimationDuration;

  /// The curve of the marker's move animation. Default to
  /// [Curves.fastOutSlowIn].
  final Curve moveAnimationCurve;

  /// The duration of the heading sector rotate animation. Default to 200ms.
  final Duration rotateAnimationDuration;

  /// The curve of the heading sector rotate animation. Default to
  /// [Curves.easeInOut].
  final Curve rotateAnimationCurve;

  /// Create a LocationMarkerLayerOptions.
  LocationMarkerLayerOptions({
    Stream<LocationMarkerPosition>? positionStream,
    Stream<LocationMarkerHeading>? headingStream,
    this.marker = const DefaultLocationMarker(),
    this.markerSize = const Size(20, 20),
    this.markerDirection = MarkerDirection.top,
    this.showAccuracyCircle = true,
    this.accuracyCircleColor = const Color.fromARGB(0x18, 0x21, 0x96, 0xF3),
    this.showHeadingSector = true,
    this.headingSectorRadius = 60,
    this.headingSectorColor = const Color.fromARGB(0xCC, 0x21, 0x96, 0xF3),
    @Deprecated(
      '`markerAnimationDuration` is split into `moveAnimationDuration` and `rotateAnimationDuration`',
    )
        Duration markerAnimationDuration = const Duration(milliseconds: 200),
    Duration? moveAnimationDuration,
    Duration? rotateAnimationDuration,
    this.moveAnimationCurve = Curves.fastOutSlowIn,
    this.rotateAnimationCurve = Curves.easeInOut,
  })  : positionStream = positionStream ??
            const LocationMarkerDataStreamFactory().geolocatorPositionStream(),
        headingStream = headingStream ??
            const LocationMarkerDataStreamFactory().compassHeadingStream(),
        moveAnimationDuration =
            moveAnimationDuration ?? markerAnimationDuration,
        rotateAnimationDuration =
            rotateAnimationDuration ?? markerAnimationDuration;

  /// The duration of the animation of location update.
  @Deprecated(
    '`markerAnimationDuration` is split into `moveAnimationDuration` and `rotateAnimationDuration`',
  )
  Duration get markerAnimationDuration => moveAnimationDuration;
}

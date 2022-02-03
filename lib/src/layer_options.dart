// ignore_for_file: prefer_void_to_null

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

/// Describes the needed properties to create a location marker layer. Location
/// marker layer is a compose layer, containing 3 widgets which are
/// 1) a accuracy circle (in a circle layer)
/// 2) a heading sector (in a marker layer) and
/// 3) a marker (in the same marker layer).
class LocationMarkerLayerOptions extends LayerOptions {
  /// Describes the needed properties to create a location marker layer.
  /// Location marker layer is a compose layer, containing 3 widgets which are
  /// 1) a accuracy circle (in a circle layer)
  /// 2) a heading sector (in a marker layer) and
  /// 3) a marker (in the same marker layer).
  LocationMarkerLayerOptions({
    Key? key,
    Stream<LocationMarkerPosition?>? positionStream,
    Stream<LocationMarkerHeading>? headingStream,
    this.marker = const DefaultLocationMarker(),
    this.markerSize = const Size(20, 20),
    this.showAccuracyCircle = true,
    this.accuracyCircleColor = const Color.fromARGB(0x18, 0x21, 0x96, 0xF3),
    this.showHeadingSector = true,
    this.headingSectorRadius = 60,
    this.headingSectorColor = const Color.fromARGB(0xCC, 0x21, 0x96, 0xF3),
    this.markerAnimationDuration = const Duration(milliseconds: 200),
    Stream<Null>? rebuild,
  })  : positionStream = positionStream ??
            const LocationMarkerDataStreamFactory().geolocatorPositionStream(),
        headingStream = headingStream ??
            const LocationMarkerDataStreamFactory().compassHeadingStream(),
        super(key: key, rebuild: rebuild);

  /// A Stream that provide position data for this marker.
  final Stream<LocationMarkerPosition?> positionStream;

  /// A Stream that provide heading data for this marker.
  final Stream<LocationMarkerHeading> headingStream;

  /// The main marker widget.
  final Widget marker;

  /// The size of main marker widget.
  final Size markerSize;

  /// Whether to show accuracy circle. Android define accuracy as the radius of
  /// 68% confidence so there is a 68% probability that the true location is
  /// inside the circle.
  final bool showAccuracyCircle;

  /// The color of the accuracy circle.
  final Color accuracyCircleColor;

  /// Whether to show the heading sector.
  final bool showHeadingSector;

  /// The radius of the heading sector in pixels.
  final double headingSectorRadius;

  /// The color of the heading sector.
  final Color headingSectorColor;

  /// The duration of the animation of location update.
  final Duration markerAnimationDuration;
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map_location_marker/src/data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Creates the default [Stream] of the plugin
class LocationMarkerDataStreamFactory {
  /// Creates the default [Stream] of the plugin
  const LocationMarkerDataStreamFactory();

  /// The stream given by the [Geolocator]
  Stream<LocationMarkerPosition?> geolocatorPositionStream({
    Stream<Position>? stream,
  }) =>
      (stream ?? Geolocator.getPositionStream()).map(
        (Position position) => LocationMarkerPosition(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
        ),
      );

  /// The stream given by the [FlutterCompass]
  Stream<LocationMarkerHeading> compassHeadingStream({
    Stream<CompassEvent>? stream,
    double minAccuracy = math.pi * 0.1,
    double defAccuracy = math.pi * 0.3,
    double maxAccuracy = math.pi * 0.4,
  }) =>
      (stream ?? FlutterCompass.events ?? const Stream.empty())
          .where((compassEvent) => compassEvent.heading != null)
          .map(
            (compassEvent) => LocationMarkerHeading(
              heading: degToRadian(compassEvent.heading!),
              accuracy: (compassEvent.accuracy ?? defAccuracy).clamp(
                minAccuracy,
                maxAccuracy,
              ),
            ),
          );
}

import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'data.dart';

/// Helper class for converting the data stream which provide data in required
/// format from stream created by some existing plugin.
class LocationMarkerDataStreamFactory {
  /// Create a LocationMarkerDataStreamFactory.
  const LocationMarkerDataStreamFactory();

  /// Create a position stream from
  /// [geolocator](https://pub.dev/packages/geolocator).
  Stream<LocationMarkerPosition> geolocatorPositionStream({
    Stream<Position>? stream,
  }) {
    return (stream ?? Geolocator.getPositionStream()).map((Position position) {
      return LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    });
  }

  /// Create a heading stream from
  /// [flutter_compass](https://pub.dev/packages/flutter_compass).
  Stream<LocationMarkerHeading> compassHeadingStream({
    Stream<CompassEvent>? stream,
    double minAccuracy = pi * 0.1,
    double defAccuracy = pi * 0.3,
    double maxAccuracy = pi * 0.4,
  }) {
    return (stream ?? FlutterCompass.events ?? const Stream.empty())
        .where((CompassEvent compassEvent) => compassEvent.heading != null)
        .map((CompassEvent compassEvent) {
      return LocationMarkerHeading(
        heading: degToRadian(compassEvent.heading!),
        accuracy: (compassEvent.accuracy ?? defAccuracy).clamp(
          minAccuracy,
          maxAccuracy,
        ),
      );
    });
  }
}

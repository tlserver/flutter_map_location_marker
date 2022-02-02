import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map_location_marker/src/data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationMarkerDataStreamFactory {
  const LocationMarkerDataStreamFactory();

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

  Stream<LocationMarkerHeading> compassHeadingStream({
    Stream<CompassEvent>? stream,
    double minAccuracy = Math.pi * 0.1,
    double defAccuracy = Math.pi * 0.3,
    double maxAccuracy = Math.pi * 0.4,
  }) {
    return (stream ?? FlutterCompass.events ?? Stream.empty())
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

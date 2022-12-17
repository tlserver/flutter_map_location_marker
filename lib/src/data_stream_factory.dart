import 'dart:async';

import 'package:flutter/foundation.dart';
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
  Stream<LocationMarkerPosition?> geolocatorPositionStream({
    Stream<Position?>? stream,
  }) {
    var positionStream = stream;
    if (positionStream == null) {
      final streamController = StreamController<Position?>();
      Geolocator.getLastKnownPosition().then((lastKnown) {
        if (lastKnown != null) {
          streamController.sink.add(lastKnown);
        }
        streamController.sink.addStream(Geolocator.getPositionStream());
      });
      positionStream = streamController.stream;
    }
    return positionStream.map((Position? position) {
      return position != null
          ? LocationMarkerPosition(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
            )
          : null;
    });
  }

  /// Create a heading stream from
  /// [flutter_compass](https://pub.dev/packages/flutter_compass).
  Stream<LocationMarkerHeading?> compassHeadingStream({
    Stream<CompassEvent>? stream,
    double minAccuracy = pi * 0.1,
    double defAccuracy = pi * 0.3,
    double maxAccuracy = pi * 0.4,
  }) {
    return (stream ?? (!kIsWeb ? FlutterCompass.events! : const Stream.empty()))
        .where((CompassEvent? e) => e == null || e.heading != null)
        .map(
      (CompassEvent? e) {
        return e != null
            ? LocationMarkerHeading(
                heading: degToRadian(e.heading!),
                accuracy: (e.accuracy ?? defAccuracy).clamp(
                  minAccuracy,
                  maxAccuracy,
                ),
              )
            : null;
      },
    );
  }
}

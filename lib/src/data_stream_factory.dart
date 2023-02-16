import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'current_location_layer.dart';
import 'data.dart';
import 'exception/incorrect_setup_exception.dart';
import 'exception/permission_denied_exception.dart' as lm;
import 'exception/permission_requesting_exception.dart' as lm;

/// Helper class for converting the data stream which provide data in required
/// format from stream created by some existing plugin.
class LocationMarkerDataStreamFactory {
  /// Create a LocationMarkerDataStreamFactory.
  const LocationMarkerDataStreamFactory();

  /// Cast to a position stream from
  /// [geolocator](https://pub.dev/packages/geolocator) stream.
  Stream<LocationMarkerPosition?> fromGeolocatorPositionStream({
    Stream<Position?>? stream,
  }) {
    return (stream ?? defaultPositionStreamSource()).map((Position? position) {
      return position != null
          ? LocationMarkerPosition(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
            )
          : null;
    });
  }

  /// Cast to a position stream from
  /// [geolocator](https://pub.dev/packages/geolocator) stream.
  @Deprecated('Use fromGeolocatorPositionStream instead')
  Stream<LocationMarkerPosition?> geolocatorPositionStream({
    Stream<Position?>? stream,
  }) =>
      fromGeolocatorPositionStream(
        stream: stream,
      );

  /// Create a position stream which is used as default value of
  /// [CurrentLocationLayer.positionStream].
  Stream<Position?> defaultPositionStreamSource() {
    final streamController = StreamController<Position?>();
    Future.microtask(() async {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          streamController.sink
              .addError(const lm.PermissionRequestingException());
          permission = await Geolocator.requestPermission();
        }
        switch (permission) {
          case LocationPermission.denied:
          case LocationPermission.deniedForever:
            streamController.sink
                .addError(const lm.PermissionDeniedException());
            break;
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            try {
              final lastKnown = await Geolocator.getLastKnownPosition();
              if (lastKnown != null) {
                streamController.sink.add(lastKnown);
              }
            } catch(_) {};
            streamController.sink.addStream(Geolocator.getPositionStream());
            break;
          case LocationPermission.unableToDetermine:
            break;
        }
      } on PermissionDefinitionsNotFoundException {
        streamController.sink.addError(const IncorrectSetupException());
      }
    });
    return streamController.stream;
  }

  /// Cast to a heading stream from
  /// [flutter_compass](https://pub.dev/packages/flutter_compass) stream.
  Stream<LocationMarkerHeading?> fromCompassHeadingStream({
    Stream<CompassEvent?>? stream,
    double minAccuracy = pi * 0.1,
    double defAccuracy = pi * 0.3,
    double maxAccuracy = pi * 0.4,
  }) {
    return (stream ?? defaultHeadingStreamSource())
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

  /// Cast to a heading stream from
  /// [flutter_compass](https://pub.dev/packages/flutter_compass) stream.
  @Deprecated('Use fromCompassHeadingStream instead')
  Stream<LocationMarkerHeading?> compassHeadingStream({
    Stream<CompassEvent?>? stream,
    double minAccuracy = pi * 0.1,
    double defAccuracy = pi * 0.3,
    double maxAccuracy = pi * 0.4,
  }) =>
      fromCompassHeadingStream(
        stream: stream,
        minAccuracy: minAccuracy,
        defAccuracy: defAccuracy,
        maxAccuracy: maxAccuracy,
      );

  /// Create a heading stream which is used as default value of
  /// [CurrentLocationLayer.headingStream].
  Stream<CompassEvent?> defaultHeadingStreamSource() {
    return !kIsWeb ? FlutterCompass.events! : const Stream.empty();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../exceptions/incorrect_setup_exception.dart';
import '../exceptions/permission_denied_exception.dart' as lm;
import '../exceptions/permission_requesting_exception.dart' as lm;
import '../exceptions/service_disabled_exception.dart';
import '../widgets/current_location_layer.dart';
import 'data.dart';

/// Signature for callbacks of permission request.
typedef RequestPermissionCallback = FutureOr<LocationPermission> Function();

/// Helper class for converting the data stream which provide data in required
/// format from stream created by some existing plugin.
class LocationMarkerDataStreamFactory {
  /// Create a LocationMarkerDataStreamFactory.
  const LocationMarkerDataStreamFactory();

  /// Cast to a position stream from
  /// [geolocator](https://pub.dev/packages/geolocator) stream.
  Stream<LocationMarkerPosition?> fromGeolocatorPositionStream({
    Stream<Position?>? stream,
  }) =>
      (stream ?? defaultPositionStreamSource()).map(
        (position) => position != null
            ? LocationMarkerPosition(
                latitude: position.latitude,
                longitude: position.longitude,
                accuracy: position.accuracy,
              )
            : null,
      );

  /// Create a position stream which is used as default value of
  /// [CurrentLocationLayer.positionStream].
  Stream<Position?> defaultPositionStreamSource({
    RequestPermissionCallback? requestPermissionCallback =
        Geolocator.requestPermission,
  }) {
    final cancelFunctions = <AsyncCallback>[];
    final streamController = StreamController<Position?>.broadcast();
    streamController
      ..onListen = () async {
        try {
          var permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied &&
              requestPermissionCallback != null) {
            streamController.sink
                .addError(const lm.PermissionRequestingException());
            permission = await requestPermissionCallback();
          }
          switch (permission) {
            case LocationPermission.denied:
            case LocationPermission.deniedForever:
              if (streamController.isClosed) {
                break;
              }
              streamController.sink
                  .addError(const lm.PermissionDeniedException());
              await streamController.close();
            case LocationPermission.whileInUse:
            case LocationPermission.always:
              try {
                final serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (streamController.isClosed) {
                  break;
                }
                if (!serviceEnabled) {
                  streamController.sink
                      .addError(const ServiceDisabledException());
                }
              } on Exception catch (_) {}
              try {
                // The concept of location service doesn't exist on the web
                // platform
                if (!kIsWeb) {
                  final subscription = Geolocator.getServiceStatusStream()
                      .listen((serviceStatus) {
                    if (serviceStatus == ServiceStatus.enabled) {
                      streamController.sink.add(null);
                    } else {
                      streamController.sink
                          .addError(const ServiceDisabledException());
                    }
                  });
                  cancelFunctions.add(subscription.cancel);
                }
              } on Exception catch (_) {}
              try {
                // getLastKnownPosition is not supported on the web platform
                if (!kIsWeb) {
                  final lastKnown = await Geolocator.getLastKnownPosition();
                  if (streamController.isClosed) {
                    break;
                  }
                  if (lastKnown != null) {
                    streamController.sink.add(lastKnown);
                  }
                }
              } on Exception catch (_) {}
              try {
                final serviceEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (serviceEnabled) {
                  final position = await Geolocator.getCurrentPosition();
                  if (streamController.isClosed) {
                    break;
                  }
                  streamController.sink.add(position);
                }
              } on Exception catch (_) {}
              final subscription =
                  Geolocator.getPositionStream().listen((position) {
                streamController.sink.add(position);
              });
              cancelFunctions.add(subscription.cancel);
            case LocationPermission.unableToDetermine:
              break;
          }
        } on PermissionDefinitionsNotFoundException {
          streamController.sink.addError(const IncorrectSetupException());
        }
      }
      ..onCancel = () async {
        await Future.wait(cancelFunctions.map((callback) => callback()));
        await streamController.close();
      };
    return streamController.stream;
  }

  /// Cast to a heading stream from
  /// [flutter_compass](https://pub.dev/packages/flutter_compass) stream.
  Stream<LocationMarkerHeading?> fromCompassHeadingStream({
    Stream<CompassEvent?>? stream,
    double minAccuracy = pi * 0.1,
    double defAccuracy = pi * 0.3,
    double maxAccuracy = pi * 0.4,
  }) =>
      (stream ?? defaultHeadingStreamSource())
          .where((e) => e == null || e.heading != null)
          .map(
            (e) => e != null
                ? LocationMarkerHeading(
                    heading: degToRadian(e.heading!),
                    accuracy: e.accuracy != null
                        ? degToRadian(e.accuracy!)
                            .clamp(minAccuracy, maxAccuracy)
                        : defAccuracy,
                  )
                : null,
          );

  /// Create a heading stream which is used as default value of
  /// [CurrentLocationLayer.headingStream].
  Stream<CompassEvent?> defaultHeadingStreamSource() => FlutterCompass.events!;
}

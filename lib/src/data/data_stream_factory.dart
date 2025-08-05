import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';
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
  }) => (stream ?? defaultPositionStreamSource()).map(
    (position) =>
        position != null
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
  }) => _DpsSourceCreator(requestPermissionCallback).stream;

  /// Cast to a heading stream from
  /// [flutter_rotation_sensor](https://pub.dev/packages/flutter_rotation_sensor) stream.
  Stream<LocationMarkerHeading?> fromRotationSensorHeadingStream({
    Stream<OrientationEvent>? stream,
    double minAccuracy = pi * 0.1,
    double defAccuracy = pi * 0.3,
    double maxAccuracy = pi * 0.4,
  }) => (stream ?? defaultHeadingStreamSource()).map(
    (e) => LocationMarkerHeading(
      heading: e.eulerAngles.azimuth,
      accuracy:
          e.accuracy >= 0
              ? degToRadian(e.accuracy).clamp(minAccuracy, maxAccuracy)
              : defAccuracy,
    ),
  );

  /// Create a heading stream which is used as default value of
  /// [CurrentLocationLayer.headingStream].
  Stream<OrientationEvent> defaultHeadingStreamSource() {
    RotationSensor.samplingPeriod = SensorInterval.uiInterval;
    return RotationSensor.orientationStream;
  }
}

class _DpsSourceCreator {
  final List<AsyncCallback> cancelFunctions;
  final StreamController<Position?> streamController;
  final RequestPermissionCallback? requestPermissionCallback;

  Stream<Position?> get stream => streamController.stream;

  _DpsSourceCreator(this.requestPermissionCallback)
    : cancelFunctions = const [],
      streamController = StreamController<Position?>.broadcast() {
    streamController
      ..onListen = _onListen
      ..onCancel = _onCancel;
  }

  Future<void> _onListen() async {
    try {
      var permission = await _requestPermission();
      switch (permission) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
          _tryAddError(const lm.PermissionDeniedException());
          await streamController.close();
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          if (!kIsWeb) {
            // The concept of location service doesn't exist on the web platform
            _subscriptServiceStatic();
            // getLastKnownPosition is not supported on the web platform
            await _addLastKnownPosition();
          }
          await _addCurrentPosition();
          _subscriptPositionChanges();
        case LocationPermission.unableToDetermine:
          break;
      }
    } on PermissionDefinitionsNotFoundException {
      _tryAddError(const IncorrectSetupException());
    }
  }

  Future<LocationPermission> _requestPermission() async {
    var permission = await Geolocator.checkPermission();
    var requestPermissionCallback = this.requestPermissionCallback;
    if (permission == LocationPermission.denied &&
        requestPermissionCallback != null) {
      _tryAddError(const lm.PermissionRequestingException());
      permission = await requestPermissionCallback();
    }
    return permission;
  }

  Future<void> _addLastKnownPosition() async {
    try {
      final lastKnown = await Geolocator.getLastKnownPosition();
      _tryAddData(lastKnown);
    } on Exception catch (_) {}
  }

  Future<void> _addCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        final position = await Geolocator.getCurrentPosition();
        _tryAddData(position);
      } else {
        _tryAddError(const ServiceDisabledException());
      }
    } on Exception catch (_) {}
  }

  void _subscriptServiceStatic() {
    try {
      final subscription = Geolocator.getServiceStatusStream().listen((
        serviceStatus,
      ) {
        if (serviceStatus == ServiceStatus.enabled) {
          streamController.sink.add(null);
        } else {
          _tryAddError(const ServiceDisabledException());
        }
      });
      cancelFunctions.add(subscription.cancel);
    } on Exception catch (_) {}
  }

  void _subscriptPositionChanges() {
    final subscription = Geolocator.getPositionStream().listen(
      streamController.sink.add,
      onError: streamController.sink.addError,
      onDone: streamController.close,
    );
    cancelFunctions.add(subscription.cancel);
  }

  void _tryAddData(Position? position) {
    if (position == null || streamController.isClosed) return;
    streamController.sink.add(position);
  }

  void _tryAddError(Exception exception) {
    if (streamController.isClosed) return;
    streamController.sink.addError(exception);
  }

  Future<void> _onCancel() async {
    await Future.wait(cancelFunctions.map((callback) => callback()));
    await streamController.close();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'animated_location_marker_layer.dart';
import 'center_on_location_update.dart';
import 'data.dart';
import 'data_stream_factory.dart';
import 'style.dart';
import 'turn_on_heading_update.dart';
import 'tween.dart';

/// A layer for current location marker in [FlutterMap].
class CurrentLocationLayer extends StatefulWidget {
  /// The style to use for this location marker.
  final LocationMarkerStyle style;

  /// A Stream that provide position data for this marker. Default to
  /// [LocationMarkerDataStreamFactory.geolocatorPositionStream].
  final Stream<LocationMarkerPosition?> positionStream;

  /// A Stream that provide heading data for this marker. Default to
  /// [LocationMarkerDataStreamFactory.compassHeadingStream].
  final Stream<LocationMarkerHeading?> headingStream;

  /// The event stream for centering current location. Add a zoom level into
  /// this stream to center the current location at the provided zoom level or a
  /// null if the zoom level should be unchanged. Default to null.
  ///
  /// For more details, see
  /// [CenterFabExample](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/center_fab_example.dart).
  final Stream<double?>? centerCurrentLocationStream;

  /// The event stream for turning heading up. Default to null.
  final Stream<void>? turnHeadingUpLocationStream;

  /// When should the plugin center the current location to the map. Default to
  /// [CenterOnLocationUpdate.never].
  final CenterOnLocationUpdate centerOnLocationUpdate;

  /// When should the plugin center the current location to the map. Default to
  /// [TurnOnHeadingUpdate.never].
  final TurnOnHeadingUpdate turnOnHeadingUpdate;

  /// The duration of the animation of centering the map to the current
  /// location. Default to 200ms.
  final Duration centerAnimationDuration;

  /// The curve of the animation of centering the map to the current location.
  /// Default to [Curves.fastOutSlowIn].
  final Curve centerAnimationCurve;

  /// The duration of the animation of turning the map to align the heading.
  /// Default to 200ms.
  final Duration turnAnimationDuration;

  /// The curve of the animation of turning the map to align the heading.
  /// Default to [Curves.easeInOut].
  final Curve turnAnimationCurve;

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

  /// Create a CurrentLocationLayer.
  CurrentLocationLayer({
    super.key,
    this.style = const LocationMarkerStyle(),
    Stream<LocationMarkerPosition?>? positionStream,
    Stream<LocationMarkerHeading?>? headingStream,
    this.centerCurrentLocationStream,
    this.turnHeadingUpLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.turnOnHeadingUpdate = TurnOnHeadingUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 200),
    this.centerAnimationCurve = Curves.fastOutSlowIn,
    this.turnAnimationDuration = const Duration(milliseconds: 200),
    this.turnAnimationCurve = Curves.easeInOut,
    this.moveAnimationDuration = const Duration(milliseconds: 200),
    this.moveAnimationCurve = Curves.fastOutSlowIn,
    this.rotateAnimationDuration = const Duration(milliseconds: 200),
    this.rotateAnimationCurve = Curves.easeInOut,
  })  : positionStream = positionStream ??
            const LocationMarkerDataStreamFactory().geolocatorPositionStream(),
        headingStream = headingStream ??
            const LocationMarkerDataStreamFactory().compassHeadingStream();

  @override
  State<CurrentLocationLayer> createState() => _CurrentLocationLayerState();
}

class _CurrentLocationLayerState extends State<CurrentLocationLayer>
    with TickerProviderStateMixin {
  LocationMarkerPosition? _currentPosition;
  LocationMarkerHeading? _currentHeading;
  double? _centeringZoom;

  late bool _isFirstLocationUpdate;
  late bool _isFirstHeadingUpdate;

  late StreamSubscription<LocationMarkerPosition?> _positionStreamSubscription;
  late StreamSubscription<LocationMarkerHeading?> _headingStreamSubscription;

  /// Subscription to a stream for centering single that also include a zoom level.
  StreamSubscription<double?>? _centerCurrentLocationStreamSubscription;
  AnimationController? _centerCurrentLocationAnimationController;

  /// Subscription to a stream for single indicate turning the heading up.
  StreamSubscription<void>? _turnHeadingUpStreamSubscription;
  AnimationController? _turnHeadingUpAnimationController;

  @override
  void initState() {
    super.initState();
    _isFirstLocationUpdate = true;
    _isFirstHeadingUpdate = true;
    _subscriptPositionStream();
    _subscriptHeadingStream();
    _subscriptCenterCurrentLocationStream();
    _subscriptTurnHeadingUpStream();
  }

  @override
  void didUpdateWidget(CurrentLocationLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.positionStream != oldWidget.positionStream) {
      _positionStreamSubscription.cancel();
      _subscriptPositionStream();
    }
    if (widget.headingStream != oldWidget.headingStream) {
      _headingStreamSubscription.cancel();
      _subscriptHeadingStream();
    }
    if (widget.centerCurrentLocationStream !=
        oldWidget.centerCurrentLocationStream) {
      _centerCurrentLocationStreamSubscription?.cancel();
      _subscriptCenterCurrentLocationStream();
    }
    if (widget.turnHeadingUpLocationStream !=
        oldWidget.turnHeadingUpLocationStream) {
      _turnHeadingUpStreamSubscription?.cancel();
      _subscriptTurnHeadingUpStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _currentPosition;
    if (currentPosition != null) {
      return AnimatedLocationMarkerLayer(
        position: currentPosition,
        heading: _currentHeading,
        style: widget.style,
        moveAnimationDuration: widget.moveAnimationDuration,
        moveAnimationCurve: widget.moveAnimationCurve,
        rotateAnimationDuration: widget.rotateAnimationDuration,
        rotateAnimationCurve: widget.rotateAnimationCurve,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _headingStreamSubscription.cancel();
    _centerCurrentLocationStreamSubscription?.cancel();
    _centerCurrentLocationAnimationController?.dispose();
    _turnHeadingUpStreamSubscription?.cancel();
    _turnHeadingUpAnimationController?.dispose();
    super.dispose();
  }

  void _subscriptPositionStream() {
    _positionStreamSubscription =
        widget.positionStream.listen((LocationMarkerPosition? position) {
      setState(() => _currentPosition = position);

      bool centerCurrentLocation;
      switch (widget.centerOnLocationUpdate) {
        case CenterOnLocationUpdate.always:
          centerCurrentLocation = true;
          break;
        case CenterOnLocationUpdate.once:
          centerCurrentLocation = _isFirstLocationUpdate;
          _isFirstLocationUpdate = false;
          break;
        case CenterOnLocationUpdate.never:
          centerCurrentLocation = false;
          break;
      }
      if (centerCurrentLocation) {
        final currentPosition = _currentPosition;

        if (currentPosition == null) return;

        _moveMap(
          LatLng(currentPosition.latitude, currentPosition.longitude),
          _centeringZoom,
        );
      }
    })
          ..onError((_) => setState(() => _currentPosition = null));
  }

  void _subscriptHeadingStream() {
    _headingStreamSubscription =
        widget.headingStream.listen((LocationMarkerHeading? heading) {
      setState(() => _currentHeading = heading);

      bool turnHeadingUp;
      switch (widget.turnOnHeadingUpdate) {
        case TurnOnHeadingUpdate.always:
          turnHeadingUp = true;
          break;
        case TurnOnHeadingUpdate.once:
          turnHeadingUp = _isFirstHeadingUpdate;
          _isFirstHeadingUpdate = false;
          break;
        case TurnOnHeadingUpdate.never:
          turnHeadingUp = false;
          break;
      }
      if (turnHeadingUp) {
        final currentHeading = _currentHeading;
        if (currentHeading == null) return;

        _rotateMap(-currentHeading.heading / pi * 180);
      }
    })
          ..onError((_) => setState(() => _currentHeading = null));
  }

  void _subscriptCenterCurrentLocationStream() {
    _centerCurrentLocationStreamSubscription =
        widget.centerCurrentLocationStream?.listen((double? zoom) {
      if (_currentPosition != null) {
        _centeringZoom = zoom;

        final currentPosition = _currentPosition;
        if (currentPosition == null) return;

        _moveMap(
          LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom,
        ).whenComplete(() => _centeringZoom = null);
      }
    });
  }

  void _subscriptTurnHeadingUpStream() {
    _turnHeadingUpStreamSubscription =
        widget.turnHeadingUpLocationStream?.listen((_) {
      if (_currentHeading != null) {
        final currentHeading = _currentHeading;
        if (currentHeading == null) return;

        _rotateMap(-currentHeading.heading / pi * 180);
      }
    });
  }

  TickerFuture _moveMap(LatLng latLng, [double? zoom]) {
    final map = FlutterMapState.maybeOf(context)!;
    zoom ??= map.zoom;
    _centerCurrentLocationAnimationController?.dispose();
    _centerCurrentLocationAnimationController = AnimationController(
      duration: widget.centerAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _centerCurrentLocationAnimationController!,
      curve: widget.centerAnimationCurve,
    );
    final latTween = Tween(
      begin: map.center.latitude,
      end: latLng.latitude,
    );
    final lngTween = Tween(
      begin: map.center.longitude,
      end: latLng.longitude,
    );
    final zoomTween = Tween(
      begin: map.zoom,
      end: zoom,
    );

    _centerCurrentLocationAnimationController!.addListener(() {
      map.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
        source: MapEventSource.mapController,
      );
    });

    _centerCurrentLocationAnimationController!
        .addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _centerCurrentLocationAnimationController!.dispose();
        _centerCurrentLocationAnimationController = null;
      }
    });

    return _centerCurrentLocationAnimationController!.forward();
  }

  TickerFuture _rotateMap(double angle) {
    final map = FlutterMapState.maybeOf(context)!;
    _turnHeadingUpAnimationController?.dispose();
    _turnHeadingUpAnimationController = AnimationController(
      duration: widget.turnAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _turnHeadingUpAnimationController!,
      curve: widget.turnAnimationCurve,
    );
    final angleTween = DegreeTween(
      begin: map.rotation,
      end: angle,
    );

    _turnHeadingUpAnimationController!.addListener(() {
      map.rotate(
        angleTween.evaluate(animation),
        source: MapEventSource.mapController,
      );
    });

    _turnHeadingUpAnimationController!
        .addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _turnHeadingUpAnimationController!.dispose();
        _turnHeadingUpAnimationController = null;
      }
    });

    return _turnHeadingUpAnimationController!.forward();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'center_on_location_update.dart';
import 'data.dart';
import 'drawing/heading_sector.dart';
import 'layer_options.dart';
import 'marker_direction.dart';
import 'plugin.dart';
import 'turn_on_heading_update.dart';
import 'tween.dart';

/// A layer for location marker in [FlutterMap].
class LocationMarkerLayer extends StatefulWidget {
  /// A [LocationMarkerPlugin] instance.
  final LocationMarkerPlugin plugin;

  /// Options for drawing this layer.
  final LocationMarkerLayerOptions? locationMarkerOpts;

  /// The map that should this layer be drawn.
  final FlutterMapState map;

  /// Create a LocationMarkerLayer.
  LocationMarkerLayer(
    this.plugin,
    this.locationMarkerOpts,
    this.map,
  );

  @override
  LocationMarkerLayerState createState() => LocationMarkerLayerState();
}

/// The logic and internal state for a [LocationMarkerLayer].
class LocationMarkerLayerState extends State<LocationMarkerLayer>
    with TickerProviderStateMixin {
  late LocationMarkerLayerOptions _locationMarkerOpts;
  late bool _isFirstLocationUpdate;
  late bool _isFirstHeadingUpdate;
  LocationMarkerPosition? _currentPosition;
  LocationMarkerHeading? _currentHeading;
  late StreamSubscription<LocationMarkerPosition> _positionStreamSubscription;
  late StreamSubscription<LocationMarkerHeading> _headingStreamSubscription;
  double? _centeringZoom;

  /// Subscription to a stream for centering single that also include a zoom level.
  StreamSubscription<double?>? _centerCurrentLocationStreamSubscription;
  AnimationController? _centerCurrentLocationAnimationController;

  /// Subscription to a stream for single indicate turning the heading up.
  StreamSubscription<void>? _turnHeadingUpStreamSubscription;
  AnimationController? _turnHeadingUpAnimationController;

  @override
  void initState() {
    super.initState();
    _locationMarkerOpts =
        widget.locationMarkerOpts ?? LocationMarkerLayerOptions();
    _isFirstLocationUpdate = true;
    _isFirstHeadingUpdate = true;
    _positionStreamSubscription = _subscriptPositionStream();
    _headingStreamSubscription = _subscriptHeadingStream();
    _centerCurrentLocationStreamSubscription =
        widget.plugin.centerCurrentLocationStream?.listen((double? zoom) {
      if (_currentPosition != null) {
        _moveMap(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom,
        ).whenComplete(() => _centeringZoom = null);
        _centeringZoom = zoom;
      }
    });
    _turnHeadingUpStreamSubscription =
        widget.plugin.turnHeadingUpLocationStream?.listen((_) {
      if (_currentHeading != null) {
        _rotateMap(-_currentHeading!.heading / pi * 180);
      }
    });
  }

  @override
  void didUpdateWidget(LocationMarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previousPositionStream = _locationMarkerOpts.positionStream;
    final previousHeadingStream = _locationMarkerOpts.headingStream;
    if (widget.locationMarkerOpts != oldWidget.locationMarkerOpts) {
      _locationMarkerOpts =
          widget.locationMarkerOpts ?? LocationMarkerLayerOptions();
      if (_locationMarkerOpts.positionStream != previousPositionStream) {
        _positionStreamSubscription.cancel();
        _positionStreamSubscription = _subscriptPositionStream();
      }
      if (_locationMarkerOpts.headingStream != previousHeadingStream) {
        _headingStreamSubscription.cancel();
        _headingStreamSubscription = _subscriptHeadingStream();
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _headingStreamSubscription.cancel();
    _centerCurrentLocationStreamSubscription?.cancel();
    _turnHeadingUpStreamSubscription?.cancel();
    _centerCurrentLocationAnimationController?.dispose();
    _turnHeadingUpAnimationController?.dispose();
    super.dispose();
  }

  StreamSubscription<LocationMarkerPosition> _subscriptPositionStream() {
    return _locationMarkerOpts.positionStream.listen((position) {
      setState(() => _currentPosition = position);

      bool centerCurrentLocation;
      switch (widget.plugin.centerOnLocationUpdate) {
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
        _moveMap(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          _centeringZoom,
        );
      }
    })
      ..onError((_) => setState(() => _currentPosition = null));
  }

  StreamSubscription<LocationMarkerHeading> _subscriptHeadingStream() {
    return _locationMarkerOpts.headingStream.listen((heading) {
      setState(() => _currentHeading = heading);

      bool turnHeadingUp;
      switch (widget.plugin.turnOnHeadingUpdate) {
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
        _rotateMap(-_currentHeading!.heading / pi * 180);
      }
    })
      ..onError((_) => setState(() => _currentPosition = null));
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition != null) {
      if (_locationMarkerOpts.moveAnimationDuration == Duration.zero) {
        return _buildLocationMarker(_currentPosition!);
      } else {
        return TweenAnimationBuilder(
          tween: LocationMarkerPositionTween(
            begin: _currentPosition!,
            end: _currentPosition!,
          ),
          duration: _locationMarkerOpts.moveAnimationDuration,
          curve: _locationMarkerOpts.moveAnimationCurve,
          builder: (
            BuildContext context,
            LocationMarkerPosition position,
            Widget? child,
          ) {
            return _buildLocationMarker(position);
          },
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildLocationMarker(LocationMarkerPosition position) {
    final latLng = position.latLng;
    final diameter = _locationMarkerOpts.headingSectorRadius * 2;
    return Stack(children: [
          if (_locationMarkerOpts.showAccuracyCircle)
            CircleLayer(
              circles: [
                CircleMarker(
                  point: latLng,
                  radius: position.accuracy,
                  useRadiusInMeter: true,
                  color: _locationMarkerOpts.accuracyCircleColor,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              if (_locationMarkerOpts.showHeadingSector)
                Marker(
                  point: latLng,
                  width: diameter,
                  height: diameter,
                  builder: (_) {
                    return IgnorePointer(
                      child: StreamBuilder(
                        stream: _locationMarkerOpts.headingStream,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<LocationMarkerHeading> snapshot,
                        ) {
                          if (snapshot.hasData) {
                            return TweenAnimationBuilder(
                              tween: LocationMarkerHeadingTween(
                                begin: snapshot.data!,
                                end: snapshot.data!,
                              ),
                              duration:
                                  _locationMarkerOpts.rotateAnimationDuration,
                              curve: _locationMarkerOpts.rotateAnimationCurve,
                              builder: (
                                BuildContext context,
                                LocationMarkerHeading heading,
                                Widget? child,
                              ) {
                                return CustomPaint(
                                  size: Size.fromRadius(
                                    _locationMarkerOpts.headingSectorRadius,
                                  ),
                                  painter: HeadingSector(
                                    _locationMarkerOpts.headingSectorColor,
                                    heading.heading,
                                    heading.accuracy,
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    );
                  },
                ),
              Marker(
                point: latLng,
                width: _locationMarkerOpts.markerSize.width,
                height: _locationMarkerOpts.markerSize.height,
                builder: (_) {
                  switch (_locationMarkerOpts.markerDirection) {
                    case MarkerDirection.north:
                      return _locationMarkerOpts.marker;
                    case MarkerDirection.top:
                      return Transform.rotate(
                        angle: -widget.map.rotationRad,
                        child: _locationMarkerOpts.marker,
                      );
                    case MarkerDirection.heading:
                      return StreamBuilder(
                        stream: _locationMarkerOpts.headingStream,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<LocationMarkerHeading> snapshot,
                        ) {
                          if (snapshot.hasData) {
                            return TweenAnimationBuilder(
                              tween: LocationMarkerHeadingTween(
                                begin: snapshot.data!,
                                end: snapshot.data!,
                              ),
                              duration:
                                  _locationMarkerOpts.rotateAnimationDuration,
                              curve: _locationMarkerOpts.rotateAnimationCurve,
                              builder: (
                                BuildContext context,
                                LocationMarkerHeading heading,
                                Widget? child,
                              ) {
                                return Transform.rotate(
                                  angle: heading.heading,
                                  child: _locationMarkerOpts.marker,
                                );
                              },
                            );
                          } else {
                            return Transform.rotate(
                              angle: -widget.map.rotationRad,
                              child: _locationMarkerOpts.marker,
                            );
                          }
                        },
                      );
                  }
                },
              ),
            ],
          ),
        ],
      );
  }

  TickerFuture _moveMap(LatLng latLng, [double? zoom]) {
    zoom ??= widget.map.zoom;
    _centerCurrentLocationAnimationController?.dispose();
    _centerCurrentLocationAnimationController = AnimationController(
      duration: widget.plugin.centerAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _centerCurrentLocationAnimationController!,
      curve: widget.plugin.centerAnimationCurve,
    );
    final latTween = Tween(
      begin: widget.map.center.latitude,
      end: latLng.latitude,
    );
    final lngTween = Tween(
      begin: widget.map.center.longitude,
      end: latLng.longitude,
    );
    final zoomTween = Tween(
      begin: widget.map.zoom,
      end: zoom,
    );

    _centerCurrentLocationAnimationController!.addListener(() {
      widget.map.move(
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
    _turnHeadingUpAnimationController?.dispose();
    _turnHeadingUpAnimationController = AnimationController(
      duration: widget.plugin.turnAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _turnHeadingUpAnimationController!,
      curve: widget.plugin.turnAnimationCurve,
    );
    final angleTween = DegreeTween(
      begin: widget.map.rotation,
      end: angle,
    );

    _turnHeadingUpAnimationController!.addListener(() {
      widget.map.rotate(
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

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
import 'tween.dart';

/// A layer for location marker in [FlutterMap].
class LocationMarkerLayer extends StatefulWidget {
  /// A [LocationMarkerPlugin] instance.
  final LocationMarkerPlugin plugin;

  /// Options for drawing this layer.
  final LocationMarkerLayerOptions? locationMarkerOpts;

  /// The map that should this layer be drawn.
  final MapState map;

  /// A rebuild signal stream for GroupLayer. See [GroupLayer.stream].
  final Stream<void> stream;

  /// Create a LocationMarkerLayer.
  LocationMarkerLayer(
    this.plugin,
    this.locationMarkerOpts,
    this.map,
    this.stream,
  ) : super(
          key: locationMarkerOpts?.key,
        );

  @override
  LocationMarkerLayerState createState() => LocationMarkerLayerState();
}

/// The logic and internal state for a [LocationMarkerLayer].
class LocationMarkerLayerState extends State<LocationMarkerLayer>
    with TickerProviderStateMixin {
  late LocationMarkerLayerOptions _locationMarkerOpts;
  late bool _isFirstLocationUpdate;
  LocationMarkerPosition? _currentPosition;
  late StreamSubscription<LocationMarkerPosition> _positionStreamSubscription;
  double? _centeringZoom;

  /// A stream for centering single that also include a zoom level.
  StreamSubscription<double?>? _centerCurrentLocationStreamSubscription;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _locationMarkerOpts =
        widget.locationMarkerOpts ?? LocationMarkerLayerOptions();
    _isFirstLocationUpdate = true;
    _positionStreamSubscription = _subscriptPositionStream();
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
  }

  @override
  void didUpdateWidget(LocationMarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previousPositionStream = _locationMarkerOpts.positionStream;
    if (widget.locationMarkerOpts != oldWidget.locationMarkerOpts) {
      _locationMarkerOpts =
          widget.locationMarkerOpts ?? LocationMarkerLayerOptions();
      if (_locationMarkerOpts.positionStream != previousPositionStream) {
        _positionStreamSubscription.cancel();
        _positionStreamSubscription = _subscriptPositionStream();
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _centerCurrentLocationStreamSubscription?.cancel();
    _animationController?.dispose();
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

  @override
  Widget build(BuildContext context) {
    if (_currentPosition != null) {
      if (_locationMarkerOpts.markerAnimationDuration == Duration.zero) {
        return _buildLocationMarker(_currentPosition!);
      } else {
        return TweenAnimationBuilder(
          tween: LocationMarkerPositionTween(
            begin: _currentPosition!,
            end: _currentPosition!,
          ),
          duration: _locationMarkerOpts.markerAnimationDuration,
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
    return GroupLayer(
      GroupLayerOptions(
        group: [
          if (_locationMarkerOpts.showAccuracyCircle)
            CircleLayerOptions(
              circles: [
                CircleMarker(
                  point: latLng,
                  radius: position.accuracy,
                  useRadiusInMeter: true,
                  color: _locationMarkerOpts.accuracyCircleColor,
                ),
              ],
            ),
          MarkerLayerOptions(
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
                                  _locationMarkerOpts.markerAnimationDuration,
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
                                  _locationMarkerOpts.markerAnimationDuration,
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
      ),
      widget.map,
      widget.stream,
    );
  }

  TickerFuture _moveMap(LatLng latLng, [double? zoom]) {
    zoom ??= widget.map.zoom;
    _animationController?.dispose();
    _animationController = AnimationController(
      duration: widget.plugin.centerAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.fastOutSlowIn,
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

    _animationController!.addListener(() {
      widget.map.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
        source: MapEventSource.mapController,
      );
    });

    _animationController!.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController!.dispose();
        _animationController = null;
      }
    });

    return _animationController!.forward();
  }
}

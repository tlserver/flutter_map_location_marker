import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'center_on_location_update.dart';
import 'drawing/heading_sector.dart';
import 'layer_options.dart';
import 'plugin.dart';
import 'tween.dart';

class LocationMarkerLayer extends StatefulWidget {
  final LocationMarkerPlugin plugin;
  final LocationMarkerLayerOptions locationMarkerOpts;
  final MapState map;
  final Stream<Null> stream;

  LocationMarkerLayer(
    this.plugin,
    this.locationMarkerOpts,
    this.map,
    this.stream,
  ) : super(
          key: locationMarkerOpts.key,
        );

  @override
  _LocationMarkerLayerState createState() => _LocationMarkerLayerState();
}

class _LocationMarkerLayerState extends State<LocationMarkerLayer>
    with TickerProviderStateMixin {
  late bool _isFirstLocationUpdate;
  Position? _currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;
  StreamSubscription<double>? _moveToCurrentStreamSubscription;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _isFirstLocationUpdate = true;
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: widget.plugin.locationSettings,
    ).listen((position) {
      setState(() => _currentPosition = position);

      bool centerCurrentLocation;
      switch (widget.plugin.centerOnLocationUpdate) {
        case CenterOnLocationUpdate.always:
          centerCurrentLocation = true;
          break;
        case CenterOnLocationUpdate.once:
        // ignore: deprecated_member_use_from_same_package
        case CenterOnLocationUpdate.first:
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
            widget.map.zoom);
      }
    });
    _moveToCurrentStreamSubscription =
        widget.plugin.centerCurrentLocationStream?.listen((double zoom) {
      if (_currentPosition != null) {
        _moveMap(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom);
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _moveToCurrentStreamSubscription?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition != null) {
      if (widget.locationMarkerOpts.markerAnimationDuration == Duration.zero) {
        return _buildLocationMarker(_currentPosition!);
      } else {
        return TweenAnimationBuilder(
          tween:
              PositionTween(begin: _currentPosition!, end: _currentPosition!),
          duration: widget.locationMarkerOpts.markerAnimationDuration,
          builder: (BuildContext context, Position position, Widget? child) {
            return _buildLocationMarker(position);
          },
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildLocationMarker(Position position) {
    final latLng = LatLng(
      position.latitude,
      position.longitude,
    );
    return GroupLayer(
      GroupLayerOptions(
        group: [
          if (widget.locationMarkerOpts.showAccuracyCircle)
            CircleLayerOptions(
              circles: [
                CircleMarker(
                  point: latLng,
                  radius: position.accuracy,
                  useRadiusInMeter: true,
                  color: widget.locationMarkerOpts.accuracyCircleColor,
                ),
              ],
            ),
          MarkerLayerOptions(
            markers: [
              if (widget.locationMarkerOpts.showHeadingSector)
                Marker(
                  point: latLng,
                  width: widget.locationMarkerOpts.headingSectorRadius * 2,
                  height: widget.locationMarkerOpts.headingSectorRadius * 2,
                  builder: (_) {
                    return IgnorePointer(
                      ignoring: true,
                      child: StreamBuilder(
                        stream: FlutterCompass.events,
                        builder: (BuildContext context,
                            AsyncSnapshot<CompassEvent> snapshot) {
                          if (snapshot.data?.heading != null) {
                            return Transform.rotate(
                              angle: degToRadian(snapshot.data!.heading!),
                              child: CustomPaint(
                                size: Size.fromRadius(widget
                                    .locationMarkerOpts.headingSectorRadius),
                                painter: HeadingSector(widget
                                    .locationMarkerOpts.headingSectorColor),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    );
                  },
                ),
              Marker(
                point: latLng,
                width: widget.locationMarkerOpts.markerSize.width,
                height: widget.locationMarkerOpts.markerSize.height,
                builder: (_) => widget.locationMarkerOpts.marker,
              ),
            ],
          ),
        ],
      ),
      widget.map,
      widget.stream,
    );
  }

  void _moveMap(LatLng latLng, double zoom) {
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

    _animationController!.forward();
  }
}

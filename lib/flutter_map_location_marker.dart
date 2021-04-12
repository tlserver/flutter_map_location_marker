library flutter_map_location_marker;

import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

import 'src/position_tween.dart';

class LocationMarkerPlugin implements MapPlugin {
  /// The options passed to [Geolocator].
  /// Represents different options to configure the quality and frequency
  /// of location updates.
  final LocationOptions locationOptions;

  /// The event stream for center current location. Add a zoom level into this
  /// stream to center the current location at the provided zoom level.
  ///
  /// For more details, see CenterFabExample.
  final Stream<double> centerCurrentLocationStream;

  /// When should the plugin center the current location to the map.
  final CenterOnLocationUpdate centerOnLocationUpdate;

  /// The duration of the animation of centering the current location.
  final Duration centerAnimationDuration;

  const LocationMarkerPlugin({
    this.locationOptions = const LocationOptions(),
    @Deprecated('Do not need to specify permission type anymore, just delete it')
        geolocationPermissions,
    this.centerCurrentLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    return LocationMarkerLayer(this, options, mapState, stream);
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is LocationMarkerLayerOptions;
  }
}

/// Describes the needed properties to create a location marker layer. Location
/// marker layer is a compose layer, containing 3 widgets which are
/// 1) a accuracy circle (in a circle layer)
/// 2) a heading sector (in a marker layer) and
/// 3) a marker (in the same marker layer).
class LocationMarkerLayerOptions extends LayerOptions {
  /// The main marker widget.
  final Widget marker;

  /// The size of main marker widget.
  final Size markerSize;

  /// Whether to show accuracy circle. Android define accuracy as the radius of
  /// 68% confidence so there is a 68% probability that the true location is
  /// inside the circle.
  final bool showAccuracyCircle;

  /// The color of the accuracy circle.
  final Color accuracyCircleColor;

  /// Whether to show the heading sector.
  final bool showHeadingSector;

  /// The radius of the heading sector in pixels.
  final double headingSectorRadius;

  /// The color of the heading sector.
  final Color headingSectorColor;

  /// The duration of the animation of location update.
  final Duration markerAnimationDuration;

  LocationMarkerLayerOptions({
    Key key,
    this.marker = const DefaultLocationMarker(),
    this.markerSize = const Size(20, 20),
    this.showAccuracyCircle = true,
    this.accuracyCircleColor = const Color.fromARGB(0x18, 0x21, 0x96, 0xF3),
    this.showHeadingSector = true,
    this.headingSectorRadius = 60,
    this.headingSectorColor = const Color.fromARGB(0xCC, 0x21, 0x96, 0xF3),
    this.markerAnimationDuration = const Duration(milliseconds: 200),
    Stream<Null> rebuild,
  }) : super(
          key: key,
          rebuild: rebuild,
        );
}

enum CenterOnLocationUpdate {
  never,
  first,
  always,
}

class LocationMarkerLayerWidget extends StatelessWidget {
  final LocationMarkerPlugin plugin;
  final LocationMarkerLayerOptions options;

  LocationMarkerLayerWidget({
    this.plugin = const LocationMarkerPlugin(),
    LocationMarkerLayerOptions options,
  })  : options = options ?? LocationMarkerLayerOptions(),
        super(
          key: options?.key,
        );

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.of(context);
    return LocationMarkerLayer(plugin, options, mapState, mapState.onMoved);
  }
}

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
  bool _isFirstLocationUpdate;
  Position _currentPosition;
  StreamSubscription<Position> _positionStreamSubscription;
  StreamSubscription<double> _moveToCurrentStreamSubscription;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _isFirstLocationUpdate = true;
    _positionStreamSubscription = Geolocator.getPositionStream(
      desiredAccuracy: widget.plugin.locationOptions.accuracy,
      distanceFilter: widget.plugin.locationOptions.distanceFilter,
      forceAndroidLocationManager:
          widget.plugin.locationOptions.forceAndroidLocationManager,
      intervalDuration:
          Duration(milliseconds: widget.plugin.locationOptions.timeInterval),
    ).listen((position) {
      setState(() => _currentPosition = position);

      bool centerCurrentLocation;
      switch (widget.plugin.centerOnLocationUpdate) {
        case CenterOnLocationUpdate.always:
          centerCurrentLocation = true;
          break;
        case CenterOnLocationUpdate.first:
          centerCurrentLocation = _isFirstLocationUpdate;
          _isFirstLocationUpdate = false;
          break;
        case CenterOnLocationUpdate.never:
          centerCurrentLocation = false;
          break;
      }
      if (centerCurrentLocation) {
        _moveMap(LatLng(_currentPosition.latitude, _currentPosition.longitude),
            widget.map.zoom);
      }
    });
    _moveToCurrentStreamSubscription =
        widget.plugin.centerCurrentLocationStream?.listen((double zoom) {
      _moveMap(
          LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom);
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _moveToCurrentStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition != null) {
      if (widget.locationMarkerOpts.markerAnimationDuration == Duration.zero) {
        return _buildLocationMarker(_currentPosition);
      } else {
        return TweenAnimationBuilder(
          tween: PositionTween(begin: _currentPosition, end: _currentPosition),
          duration: widget.locationMarkerOpts.markerAnimationDuration,
          builder: (BuildContext context, Position position, Widget child) {
            return _buildLocationMarker(position);
          },
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildLocationMarker(Position position) {
    if (position.latitude == null || position.longitude == null) {
      return SizedBox.shrink();
    }
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
                  radius: position.accuracy ?? 0,
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
                    return StreamBuilder(
                      stream: FlutterCompass.events,
                      builder: (BuildContext context,
                          AsyncSnapshot<CompassEvent> snapshot) {
                        if (snapshot.hasData) {
                          return Transform.rotate(
                            angle: degToRadian(snapshot.data.heading),
                            child: CustomPaint(
                              size: Size.fromRadius(widget
                                  .locationMarkerOpts.headingSectorRadius),
                              painter: HeadingSector(
                                  widget.locationMarkerOpts.headingSectorColor),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
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
    if (_animationController != null) {
      _animationController.dispose();
    }
    _animationController = AnimationController(
      duration: widget.plugin.centerAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _animationController,
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

    _animationController.addListener(() {
      widget.map.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    _animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController.dispose();
        _animationController = null;
      }
    });

    _animationController.forward();
  }
}

class DefaultLocationMarker extends StatelessWidget {
  final Color color;
  final Widget child;

  const DefaultLocationMarker({
    Key key,
    this.color = const Color.fromARGB(0xFF, 0x21, 0x96, 0xF3),
    this.child,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}

class HeadingSector extends CustomPainter {
  final Color color;

  HeadingSector(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );
    canvas.drawArc(
      rect,
      Math.pi * 6 / 5,
      Math.pi * 3 / 5,
      true,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(color.opacity * 1.0),
            color.withOpacity(color.opacity * 0.6),
            color.withOpacity(color.opacity * 0.3),
            color.withOpacity(color.opacity * 0.1),
            color.withOpacity(color.opacity * 0.0),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(HeadingSector oldDelegate) {
    return oldDelegate.color == color;
  }
}

/// A flutter_map plugin for displaying device current location.
library flutter_map_location_marker;

import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'src/position_tween.dart';

class LocationMarkerPlugin implements MapPlugin {
  /// The settings passed to [Geolocator].
  /// Represents different settings to configure the quality and frequency
  /// of location updates.
  final LocationSettings locationSettings;

  /// The event stream for center current location. Add a zoom level into this
  /// stream to center the current location at the provided zoom level.
  ///
  /// For more details, see CenterFabExample.
  final Stream<double>? centerCurrentLocationStream;

  /// When should the plugin center the current location to the map.
  final CenterOnLocationUpdate centerOnLocationUpdate;

  /// The duration of the animation of centering the current location.
  final Duration centerAnimationDuration;

  const LocationMarkerPlugin({
    this.locationSettings = const LocationSettings(),
    this.centerCurrentLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    return LocationMarkerLayer(
        this, options as LocationMarkerLayerOptions, mapState, stream);
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

  /// The error handling function, called when received a error event from
  /// position stream
  final void Function(Object error)? errorHandler;

  LocationMarkerLayerOptions({
    Key? key,
    this.marker = const DefaultLocationMarker(),
    this.markerSize = const Size(20, 20),
    this.showAccuracyCircle = true,
    this.accuracyCircleColor = const Color.fromARGB(0x18, 0x21, 0x96, 0xF3),
    this.showHeadingSector = true,
    this.headingSectorRadius = 60,
    this.headingSectorColor = const Color.fromARGB(0xCC, 0x21, 0x96, 0xF3),
    this.markerAnimationDuration = const Duration(milliseconds: 200),
    this.errorHandler,
    Stream<Null>? rebuild,
  }) : super(
          key: key,
          rebuild: rebuild,
        );
}

enum CenterOnLocationUpdate {
  never,
  once,
  @Deprecated('Use `once` instead')
  first,
  always,
}

class LocationMarkerLayerWidget extends StatelessWidget {
  final LocationMarkerPlugin plugin;
  final LocationMarkerLayerOptions options;

  LocationMarkerLayerWidget({
    this.plugin = const LocationMarkerPlugin(),
    LocationMarkerLayerOptions? options,
  })  : options = options ?? LocationMarkerLayerOptions(),
        super(
          key: options?.key,
        );

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
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
  late bool _isFirstLocationUpdate;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<double>? _moveToCurrentStreamSubscription;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _isFirstLocationUpdate = true;
    _positionStreamSubscription = _subscribePositionStream();
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
  void didUpdateWidget(covariant LocationMarkerLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plugin.locationSettings != widget.plugin.locationSettings) {
      _positionStreamSubscription?.cancel().then((_) {
        if (mounted) {
          _positionStreamSubscription = _subscribePositionStream();
        }
      });
      _positionStreamSubscription = null;
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _moveToCurrentStreamSubscription?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  StreamSubscription<Position> _subscribePositionStream() {
    return Geolocator.getPositionStream(
            locationSettings: widget.plugin.locationSettings)
        .listen(_handlePositionUpdate,
            onError: widget.locationMarkerOpts.errorHandler ?? (_) {});
  }

  void _handlePositionUpdate(Position position) {
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
      _moveMap(LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          widget.map.zoom);
    }
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

class DefaultLocationMarker extends StatelessWidget {
  final Color color;
  final Widget? child;

  const DefaultLocationMarker({
    Key? key,
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

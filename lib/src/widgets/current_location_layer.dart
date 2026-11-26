import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/data.dart';
import '../data/data_stream_factory.dart';
import '../data/tween.dart';
import '../exceptions/incorrect_setup_exception.dart';
import '../exceptions/permission_denied_exception.dart';
import '../exceptions/permission_requesting_exception.dart';
import '../exceptions/service_disabled_exception.dart';
import '../exceptions/unsupported_exception.dart';
import '../options/align_on_update.dart';
import '../options/focal_point.dart';
import '../options/indicators.dart';
import '../options/style.dart';
import 'location_marker_layer.dart';

/// A callback function that handles exceptions thrown from position stream or
/// heading stream. It should return `null` to indicate that the exception is
/// already handled, or return an [Exception] (or its subclass) to indicate that
/// the exception is not handled.
typedef ExceptionCallback = Exception? Function(Exception exception);

/// A default error handler for [CurrentLocationLayer]. It directly returns the
/// exception unchanged.
Exception? defaultErrorHandler(Exception exception) => exception;

/// A layer for current location marker in [FlutterMap].
class CurrentLocationLayer extends StatefulWidget {
  /// The style to use for this location marker.
  final LocationMarkerStyle style;

  /// A stream that provides position data for this marker. Defaults to
  /// [LocationMarkerDataStreamFactory.fromGeolocatorPositionStream].
  final Stream<LocationMarkerPosition?>? positionStream;

  /// A stream that provides heading data for this marker. Defaults to
  /// [LocationMarkerDataStreamFactory.fromRotationSensorHeadingStream].
  final Stream<LocationMarkerHeading?>? headingStream;

  /// A screen point to align the marker when an 'align position event' is
  /// emitted. An 'align position event' is emitted under the following
  /// circumstances:
  /// 1. The first location update occurs, and [alignPositionOnUpdate] is set
  ///   to [AlignOnUpdate.once] or [AlignOnUpdate.always].
  /// 2. Any subsequent location update occurs, and [alignPositionOnUpdate] is
  ///   set to [AlignOnUpdate.always].
  /// 3. An event from [alignPositionStream] is received.
  /// Defaults to the center of the map widget.
  final FocalPoint focalPoint;

  /// A stream that emits an 'align position event'. Emit an event with a
  /// optional zoom level to this stream to align the marker position to the
  /// focal point at the specified zoom level. If null is emitted, the zoom
  /// level remains unchanged. Defaults to null.
  ///
  /// For more details, see
  /// [CenterFabExample](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/center_fab_example.dart).
  final Stream<double?>? alignPositionStream;

  /// When should the map follow current location. Default to
  /// [AlignOnUpdate.never].
  final AlignOnUpdate alignPositionOnUpdate;

  /// The duration of the animation of following the map to the current
  /// location. Default to 200ms.
  final Duration alignPositionAnimationDuration;

  /// The curve of the animation of following the map to the current location.
  /// Default to [Curves.fastOutSlowIn].
  final Curve alignPositionAnimationCurve;

  /// A stream that emits an 'align direction event'. Emit an event to this
  /// stream to align the marker direction upwards. Defaults to null.
  final Stream<void>? alignDirectionStream;

  /// When should the plugin rotate the map to keep the heading upward. Default
  /// to [AlignOnUpdate.never].
  final AlignOnUpdate alignDirectionOnUpdate;

  /// The duration of the animation of turning the map to align the heading.
  /// Default to 120ms.
  final Duration alignDirectionAnimationDuration;

  /// The curve of the animation of turning the map to align the heading.
  /// Default to [Curves.easeOut].
  final Curve alignDirectionAnimationCurve;

  /// The duration of the marker's move animation. Default to 200ms.
  final Duration moveAnimationDuration;

  /// The curve of the marker's move animation. Default to
  /// [Curves.fastOutSlowIn].
  final Curve moveAnimationCurve;

  /// The duration of the heading sector rotate animation. Default to 120ms.
  final Duration rotateAnimationDuration;

  /// The curve of the heading sector rotate animation. Default to
  /// [Curves.easeOut].
  final Curve rotateAnimationCurve;

  /// Minimum absolute zoom-level difference required to run map align
  /// animation. If `|currentZoom - targetZoom|` is less than or equal to this
  /// threshold, zoom change alone will not trigger map movement animation.
  /// Defaults to `0.01`.
  final double zoomThreshold;

  /// Minimum screen-space distance (in pixels) required to update position.
  /// Applied to both marker movement and map alignment movement. Changes less
  /// than or equal to this threshold are ignored. Defaults to `2.0` pixels.
  final double positionThreshold;

  /// Minimum angular difference (in radians) required to update heading.
  /// Applied to both marker rotation and map rotation. Changes less than or
  /// equal to this threshold are ignored. Defaults to `π / 100` radians.
  final double headingThreshold;

  /// The indicators which will display when in special status.
  @Deprecated('Use errorWidgets instead.')
  final LocationMarkerIndicators indicators;

  /// A handler called when an exception is thrown from position stream or
  /// heading stream. This is for customizing the behavior of the plugin when an
  /// exception occurs.
  ///
  /// The handler should return `null` to indicate that the exception is already
  /// handled, or return an [Exception] (or its subclass) to indicate that the
  /// exception is not handled. If the returned exception is a plugin-recognized
  /// exception type, it will be handled by this plugin.
  ///
  /// Defaults to [defaultErrorHandler].
  final ExceptionCallback errorHandler;

  /// The indicators which will display when in special status.
  final Map<Type, Widget> errorWidgets;

  /// Create a CurrentLocationLayer.
  const CurrentLocationLayer({
    super.key,
    this.style = const LocationMarkerStyle(),
    this.positionStream,
    this.headingStream,
    this.focalPoint = const FocalPoint(),
    this.alignPositionStream,
    this.alignPositionOnUpdate = AlignOnUpdate.never,
    this.alignDirectionStream,
    this.alignDirectionOnUpdate = AlignOnUpdate.never,
    this.alignPositionAnimationDuration = const Duration(milliseconds: 200),
    this.alignPositionAnimationCurve = Curves.fastOutSlowIn,
    this.alignDirectionAnimationDuration = const Duration(milliseconds: 120),
    this.alignDirectionAnimationCurve = Curves.easeOut,
    this.moveAnimationDuration = const Duration(milliseconds: 200),
    this.moveAnimationCurve = Curves.fastOutSlowIn,
    this.rotateAnimationDuration = const Duration(milliseconds: 120),
    this.rotateAnimationCurve = Curves.easeOut,
    this.zoomThreshold = 0.01,
    this.positionThreshold = 2,
    this.headingThreshold = pi / 100,
    @Deprecated('Use errorWidgets instead.')
    this.indicators = const LocationMarkerIndicators(),
    this.errorHandler = defaultErrorHandler,
    this.errorWidgets = const {},
  });

  @override
  State<CurrentLocationLayer> createState() => _CurrentLocationLayerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', style))
      ..add(DiagnosticsProperty('positionStream', positionStream))
      ..add(DiagnosticsProperty('headingStream', headingStream))
      ..add(DiagnosticsProperty('focalPoint', focalPoint))
      ..add(DiagnosticsProperty('alignPositionStream', alignPositionStream))
      ..add(DiagnosticsProperty('alignDirectionStream', alignDirectionStream))
      ..add(EnumProperty('alignPositionOnUpdate', alignPositionOnUpdate))
      ..add(EnumProperty('alignDirectionOnUpdate', alignDirectionOnUpdate))
      ..add(
        DiagnosticsProperty(
          'alignPositionAnimationDuration',
          alignPositionAnimationDuration,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'alignPositionAnimationCurve',
          alignPositionAnimationCurve,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'alignDirectionAnimationDuration',
          alignDirectionAnimationDuration,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'alignDirectionAnimationCurve',
          alignDirectionAnimationCurve,
        ),
      )
      ..add(DiagnosticsProperty('moveAnimationDuration', moveAnimationDuration))
      ..add(DiagnosticsProperty('moveAnimationCurve', moveAnimationCurve))
      ..add(
        DiagnosticsProperty('rotateAnimationDuration', rotateAnimationDuration),
      )
      ..add(DiagnosticsProperty('rotateAnimationCurve', rotateAnimationCurve))
      ..add(DiagnosticsProperty('zoomThreshold', zoomThreshold))
      ..add(DiagnosticsProperty('positionThreshold', positionThreshold))
      ..add(DiagnosticsProperty('headingThreshold', headingThreshold))
      // ignore: deprecated_member_use_from_same_package
      ..add(DiagnosticsProperty('indicators', indicators))
      ..add(
        ObjectFlagProperty<ExceptionCallback>.has('errorHandler', errorHandler),
      )
      ..add(DiagnosticsProperty('errorWidgets', errorWidgets));
  }
}

class _CurrentLocationLayerState extends State<CurrentLocationLayer>
    with TickerProviderStateMixin {
  LocationMarkerPosition? _animatingPosition;
  LocationMarkerHeading? _animatingHeading;
  LocationMarkerPosition? _markerPosition;
  LocationMarkerHeading? _markerHeading;
  LatLng? _mapPosition;
  double? _mapHeading;
  double? _followingZoom;

  bool _ready = false;
  Exception? _exception;
  bool _isFirstLocationUpdate = true;
  bool _isFirstHeadingUpdate = true;

  late StreamSubscription<LocationMarkerPosition?> _positionSubscription;
  StreamSubscription<MapEvent>? _mapEventSubscription;
  StreamSubscription<LocationMarkerHeading?>? _headingSubscription;
  MapController? _mapController;

  /// Subscription to a stream for following single that also include a zoom
  /// level.
  StreamSubscription<double?>? _alignPositionSubscription;

  /// Subscription to a stream for single indicate turning the heading up.
  StreamSubscription<void>? _alignDirectionSubscription;

  AnimationController? _moveMapAnimationController;
  AnimationController? _moveMarkerAnimationController;
  AnimationController? _rotateMapAnimationController;
  AnimationController? _rotateMarkerAnimationController;

  @override
  void initState() {
    super.initState();
    _subscriptPositionStream();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = MapController.of(context);
    if (identical(controller, _mapController)) {
      return;
    }

    _mapEventSubscription?.cancel();
    _mapController = controller;
    _mapEventSubscription = controller.mapEventStream.listen((event) {
      if (event.source != MapEventSource.mapController) {
        switch (event) {
          case MapEventMove _:
            _mapPosition = null;
          case MapEventRotate _:
            _mapHeading = null;
        }
      }
    });
  }

  @override
  void didUpdateWidget(CurrentLocationLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.positionStream != oldWidget.positionStream) {
      _positionSubscription.cancel();
      _subscriptPositionStream();
    }
    if (_ready) {
      if (widget.headingStream != oldWidget.headingStream) {
        _headingSubscription?.cancel();
        _headingSubscription = null;
        _subscriptHeadingStream();
      }
      if (widget.alignPositionStream != oldWidget.alignPositionStream) {
        _alignPositionSubscription?.cancel();
        _alignPositionSubscription = null;
        _subscriptAlignPositionStream();
      }
      if (widget.alignDirectionStream != oldWidget.alignDirectionStream) {
        _alignDirectionSubscription?.cancel();
        _alignDirectionSubscription = null;
        _subscriptAlignDirectionStream();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const empty = SizedBox.shrink();
    final exception = _exception;
    final animatingPosition = _animatingPosition;
    if (exception != null) {
      return widget.errorWidgets[exception.runtimeType] ??
          switch (exception) {
            IncorrectSetupException _ =>
              _buildHighlightedDebugText(
                    'LocationMarker plugin has not been setup correctly. '
                    'Please follow the instructions in the documentation.',
                  ) ??
                  empty,
            UnsupportedException _ =>
              _buildDebugText('Unsupported Platform') ?? empty,
            PermissionRequestingException _ =>
              // ignore: deprecated_member_use_from_same_package
              widget.indicators.permissionRequesting ??
                  _buildDebugText('Location Access Permission Requesting') ??
                  empty,
            PermissionDeniedException _ =>
              // ignore: deprecated_member_use_from_same_package
              widget.indicators.permissionDenied ??
                  _buildDebugText('Location Access Permission Denied') ??
                  empty,
            ServiceDisabledException _ =>
              // ignore: deprecated_member_use_from_same_package
              widget.indicators.serviceDisabled ??
                  _buildDebugText('Location Service Disabled') ??
                  empty,
            _ => empty,
          };
    } else if (animatingPosition != null) {
      return LocationMarkerLayer(
        position: animatingPosition,
        heading: _animatingHeading,
        style: widget.style,
      );
    } else {
      return empty;
    }
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    _positionSubscription.cancel();
    _headingSubscription?.cancel();
    _alignPositionSubscription?.cancel();
    _alignDirectionSubscription?.cancel();
    _moveMapAnimationController?.dispose();
    _moveMarkerAnimationController?.dispose();
    _rotateMapAnimationController?.dispose();
    _rotateMarkerAnimationController?.dispose();
    super.dispose();
  }

  Widget? _buildHighlightedDebugText(String message) => kDebugMode
      ? SizedBox.expand(
          child: ColoredBox(
            color: Colors.red.withAlpha(0x80),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(message, style: TextStyle(fontSize: 26)),
            ),
          ),
        )
      : null;

  Widget? _buildDebugText(String message) => kDebugMode
      ? Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              '$message\n(Debug Mode Only)',
              textAlign: TextAlign.right,
            ),
          ),
        )
      : null;

  void _subscriptPositionStream() {
    final positionStream =
        widget.positionStream ??
        const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();
    _positionSubscription = positionStream.listen(
      (position) {
        if (!mounted) {
          return;
        }
        if (position == null) {
          if (_ready) {
            setState(() {
              _ready = false;
              _animatingPosition = null;
              _markerPosition = null;
              _headingSubscription?.cancel();
              _headingSubscription = null;
              _animatingHeading = null;
              _markerHeading = null;
            });
          }
        } else {
          if (!_ready) {
            _subscriptHeadingStream();
            _subscriptAlignPositionStream();
            _subscriptAlignDirectionStream();
            setState(() => _ready = true);
          }
          _moveMarker(position);

          final update = widget.alignPositionOnUpdate;
          if (update == .always || update == .once && _isFirstLocationUpdate) {
            _moveMap(position.latLng, _followingZoom);
            _isFirstLocationUpdate = false;
          }
        }
      },
      onError: (error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _exception = widget.errorHandler(error);
          _headingSubscription?.cancel();
          _headingSubscription = null;
          _animatingHeading = null;
          _markerHeading = null;
        });
      },
    );
  }

  void _subscriptHeadingStream() {
    if (_headingSubscription != null) {
      return;
    }
    final headingStream =
        widget.headingStream ??
        const LocationMarkerDataStreamFactory()
            .fromRotationSensorHeadingStream();
    _headingSubscription = headingStream.listen(
      (heading) {
        if (!mounted) {
          return;
        }
        if (heading == null) {
          if (_animatingHeading != null) {
            setState(() => _animatingHeading = null);
          }
        } else {
          if (_ready) {
            _rotateMarker(heading);

            final update = widget.alignDirectionOnUpdate;
            if (update == .always || update == .once && _isFirstHeadingUpdate) {
              _rotateMap(-heading.heading % (2 * pi));
              _isFirstHeadingUpdate = false;
            }
          } else {
            _animatingHeading = heading;
          }
        }
      },
      onError: (error) {
        if (!mounted) {
          return;
        }
        error = widget.errorHandler(error);
        if (error is UnsupportedException) {
          if (kDebugMode) {
            print(error);
          }
        }
        if (_animatingHeading != null) {
          setState(() => _animatingHeading = null);
        }
      },
    );
  }

  void _subscriptAlignPositionStream() {
    if (_alignPositionSubscription != null) {
      return;
    }
    _alignPositionSubscription = widget.alignPositionStream?.listen((zoom) {
      if (!mounted) {
        return;
      }
      if (_animatingPosition != null) {
        _followingZoom = zoom;
        _moveMap(
          LatLng(_animatingPosition!.latitude, _animatingPosition!.longitude),
          zoom,
        ).whenComplete(() => _followingZoom = null);
      }
    });
  }

  void _subscriptAlignDirectionStream() {
    if (_alignDirectionSubscription != null) {
      return;
    }
    _alignDirectionSubscription = widget.alignDirectionStream?.listen((_) {
      if (!mounted) {
        return;
      }
      if (_animatingHeading != null) {
        _rotateMap(-_animatingHeading!.heading % (2 * pi));
      }
    });
  }

  bool _inBounds(LocationMarkerPosition? position) {
    if (position == null) return false;

    const distance = Distance();
    final camera = MapCamera.of(context);

    final so = camera.latLngToScreenOffset(position.latLng);
    final a = camera.getOffsetFromOrigin(position.latLng);
    final b = camera.getOffsetFromOrigin(
      distance.offset(position.latLng, position.accuracy, 180),
    );

    final style = widget.style;
    final markerRadius = style.markerSize.longestSide / 2;
    final headingSectorRadius = style.showHeadingSector
        ? style.headingSectorRadius
        : 0.0;
    final accuracyCircleRadius = style.showAccuracyCircle
        ? (a - b).distance
        : 0.0;
    final maxRadius = max(
      max(markerRadius, headingSectorRadius),
      accuracyCircleRadius,
    );

    return (Offset.zero & camera.nonRotatedSize).overlaps(
      Rect.fromCircle(center: so, radius: maxRadius),
    );
  }

  double _positionDistance(LatLng? oldPosition, LatLng? newPosition) {
    if (oldPosition == null || newPosition == null) return double.infinity;
    final camera = MapCamera.of(context);
    final oldOffset = camera.latLngToScreenOffset(oldPosition);
    final newOffset = camera.latLngToScreenOffset(newPosition);
    return (newOffset - oldOffset).distance;
  }

  double _headingDifferent(double? oldHeading, double? newHeading) {
    if (oldHeading == null || newHeading == null) return double.infinity;
    var difference = (newHeading - oldHeading).abs();
    return min(difference, pi * 2 - difference);
  }

  TickerFuture _moveMarker(LocationMarkerPosition position) {
    if (_positionDistance(_markerPosition?.latLng, position.latLng) >
        widget.positionThreshold) {
      _markerPosition = position;
      _moveMarkerAnimationController?.dispose();
      _moveMarkerAnimationController = null;
      if (_inBounds(position) || _inBounds(_animatingPosition)) {
        _moveMarkerAnimationController = AnimationController(
          duration: widget.moveAnimationDuration,
          vsync: this,
        );
        final animation = CurvedAnimation(
          parent: _moveMarkerAnimationController!,
          curve: widget.moveAnimationCurve,
        );
        final positionTween = LocationMarkerPositionTween(
          begin: _animatingPosition ?? position,
          end: position,
        );

        _moveMarkerAnimationController!.addListener(() {
          setState(
            () => _animatingPosition = positionTween.evaluate(animation),
          );
        });

        _moveMarkerAnimationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            _moveMarkerAnimationController!.dispose();
            _moveMarkerAnimationController = null;
          }
        });

        return _moveMarkerAnimationController!.forward();
      } else {
        setState(() => _animatingPosition = position);
      }
    }
    return TickerFuture.complete();
  }

  TickerFuture _moveMap(LatLng latLng, [double? zoom]) {
    final camera = MapCamera.of(context);
    final options = MapOptions.of(context);
    zoom ??= camera.zoom;

    final projectedFocalPoint = widget.focalPoint.project(
      camera.nonRotatedSize,
    );

    final LatLng beginLatLng;
    if (projectedFocalPoint == Offset.zero) {
      beginLatLng = camera.center;
    } else {
      final crs = options.crs;
      final mapCenter = crs.latLngToOffset(camera.center, camera.zoom);
      final followPoint = camera.rotatePoint(
        mapCenter,
        mapCenter + projectedFocalPoint,
      );
      beginLatLng = crs.offsetToLatLng(followPoint, camera.zoom);
    }

    if ((camera.zoom - zoom).abs() > widget.zoomThreshold ||
        _positionDistance(_mapPosition, latLng) > widget.positionThreshold) {
      _mapPosition = latLng;
      _moveMapAnimationController?.dispose();
      _moveMapAnimationController = AnimationController(
        duration: widget.alignPositionAnimationDuration,
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: _moveMapAnimationController!,
        curve: widget.alignPositionAnimationCurve,
      );
      final latTween = Tween(begin: beginLatLng.latitude, end: latLng.latitude);
      final lngTween = Tween(
        begin: beginLatLng.longitude,
        end: latLng.longitude,
      );
      final zoomTween = Tween(begin: camera.zoom, end: zoom);

      _moveMapAnimationController!.addListener(() {
        final evaluatedLatLng = LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        );
        final evaluatedZoom = zoomTween.evaluate(animation);

        MapController.of(
          context,
        ).move(evaluatedLatLng, evaluatedZoom, offset: projectedFocalPoint);
      });

      _moveMapAnimationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _moveMapAnimationController!.dispose();
          _moveMapAnimationController = null;
        }
      });

      return _moveMapAnimationController!.forward();
    }
    return TickerFuture.complete();
  }

  TickerFuture _rotateMarker(LocationMarkerHeading heading) {
    if (_headingDifferent(_markerHeading?.heading, heading.heading) >
        widget.headingThreshold) {
      _markerHeading = heading;
      _rotateMarkerAnimationController?.dispose();
      _rotateMarkerAnimationController = null;
      if (_inBounds(_animatingPosition)) {
        _rotateMarkerAnimationController = AnimationController(
          duration: widget.rotateAnimationDuration,
          vsync: this,
        );
        final animation = CurvedAnimation(
          parent: _rotateMarkerAnimationController!,
          curve: widget.rotateAnimationCurve,
        );
        final headingTween = LocationMarkerHeadingTween(
          begin: _animatingHeading ?? heading,
          end: heading,
        );

        _rotateMarkerAnimationController!.addListener(() {
          if (_ready) {
            setState(
              () => _animatingHeading = headingTween.evaluate(animation),
            );
          }
        });

        _rotateMarkerAnimationController!.addStatusListener((status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            _rotateMarkerAnimationController!.dispose();
            _rotateMarkerAnimationController = null;
          }
        });

        return _rotateMarkerAnimationController!.forward();
      } else {
        setState(() => _animatingHeading = heading);
      }
    }
    return TickerFuture.complete();
  }

  TickerFuture _rotateMap(double angle) {
    final camera = MapCamera.of(context);
    if (_headingDifferent(_mapHeading, angle) > widget.headingThreshold) {
      _mapHeading = angle;
      _rotateMapAnimationController?.dispose();
      _rotateMapAnimationController = AnimationController(
        duration: widget.alignDirectionAnimationDuration,
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: _rotateMapAnimationController!,
        curve: widget.alignDirectionAnimationCurve,
      );
      final angleTween = RadiusTween(begin: camera.rotationRad, end: angle);

      final projectedFocalPoint = widget.focalPoint.project(
        camera.nonRotatedSize,
      );

      _rotateMapAnimationController!.addListener(() {
        final evaluatedAngle = angleTween.evaluate(animation) / pi * 180;

        if (projectedFocalPoint == Offset.zero) {
          MapController.of(context).rotate(evaluatedAngle);
        } else {
          MapController.of(
            context,
          ).rotateAroundPoint(evaluatedAngle, offset: projectedFocalPoint);
        }
      });

      _rotateMapAnimationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _rotateMapAnimationController!.dispose();
          _rotateMapAnimationController = null;
        }
      });

      return _rotateMapAnimationController!.forward();
    }
    return TickerFuture.complete();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('_ready', _ready))
      ..add(DiagnosticsProperty('_exception', _exception))
      ..add(DiagnosticsProperty('_animatingPosition', _animatingPosition))
      ..add(DiagnosticsProperty('_animatingHeading', _animatingHeading))
      ..add(DoubleProperty('_followingZoom', _followingZoom))
      ..add(
        DiagnosticsProperty('_isFirstLocationUpdate', _isFirstLocationUpdate),
      )
      ..add(DiagnosticsProperty('_isFirstHeadingUpdate', _isFirstHeadingUpdate))
      ..add(DiagnosticsProperty('_positionSubscription', _positionSubscription))
      ..add(DiagnosticsProperty('_headingSubscription', _headingSubscription))
      ..add(
        DiagnosticsProperty(
          '_alignPositionSubscription',
          _alignPositionSubscription,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_alignDirectionSubscription',
          _alignDirectionSubscription,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_moveMapAnimationController',
          _moveMapAnimationController,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_moveMarkerAnimationController',
          _moveMarkerAnimationController,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_rotateMapAnimationController',
          _rotateMapAnimationController,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_rotateMarkerAnimationController',
          _rotateMarkerAnimationController,
        ),
      );
  }
}

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
import '../options/align_on_update.dart';
import '../options/focal_point.dart';
import '../options/indicators.dart';
import '../options/style.dart';
import 'location_marker_layer.dart';

/// A layer for current location marker in [FlutterMap].
class CurrentLocationLayer extends StatefulWidget {
  /// The style to use for this location marker.
  final LocationMarkerStyle style;

  /// A stream that provide position data for this marker. Defaults to
  /// [LocationMarkerDataStreamFactory.fromGeolocatorPositionStream].
  final Stream<LocationMarkerPosition?>? positionStream;

  /// A stream that provide heading data for this marker. Defaults to
  /// [LocationMarkerDataStreamFactory.fromCompassHeadingStream].
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
  /// Default to 50ms.
  final Duration alignDirectionAnimationDuration;

  /// The curve of the animation of turning the map to align the heading.
  /// Default to [Curves.easeInOut].
  final Curve alignDirectionAnimationCurve;

  /// The duration of the marker's move animation. Default to 200ms.
  final Duration moveAnimationDuration;

  /// The curve of the marker's move animation. Default to
  /// [Curves.fastOutSlowIn].
  final Curve moveAnimationCurve;

  /// The duration of the heading sector rotate animation. Default to 50ms.
  final Duration rotateAnimationDuration;

  /// The curve of the heading sector rotate animation. Default to
  /// [Curves.easeInOut].
  final Curve rotateAnimationCurve;

  /// The indicators which will display when in special status.
  final LocationMarkerIndicators indicators;

  /// Create a CurrentLocationLayer.
  CurrentLocationLayer({
    super.key,
    this.style = const LocationMarkerStyle(),
    this.positionStream,
    this.headingStream,
    FocalPoint? focalPoint,
    Stream<double?>? alignPositionStream,
    AlignOnUpdate? alignPositionOnUpdate,
    Stream<void>? alignDirectionStream,
    AlignOnUpdate? alignDirectionOnUpdate,
    Duration? alignPositionAnimationDuration,
    Curve? alignPositionAnimationCurve,
    Duration? alignDirectionAnimationDuration,
    Curve? alignDirectionAnimationCurve,
    this.moveAnimationDuration = const Duration(milliseconds: 200),
    this.moveAnimationCurve = Curves.fastOutSlowIn,
    this.rotateAnimationDuration = const Duration(milliseconds: 50),
    this.rotateAnimationCurve = Curves.easeInOut,
    this.indicators = const LocationMarkerIndicators(),
    @Deprecated("Use 'focalPoint' instead.") Point<double>? followScreenPoint,
    @Deprecated("Use 'focalPoint' instead.")
    Point<double>? followScreenPointOffset,
    @Deprecated("Use 'alignPositionStream' instead.")
    Stream<double?>? followCurrentLocationStream,
    @Deprecated("Use 'alignDirectionStream' instead.")
    Stream<void>? turnHeadingUpLocationStream,
    @Deprecated("Use 'alignPositionOnUpdate' instead.")
    AlignOnUpdate followOnLocationUpdate = AlignOnUpdate.never,
    @Deprecated("Use 'alignDirectionOnUpdate' instead.")
    AlignOnUpdate turnOnHeadingUpdate = AlignOnUpdate.never,
    @Deprecated("Use 'alignPositionAnimationDuration' instead.")
    Duration followAnimationDuration = const Duration(milliseconds: 200),
    @Deprecated("Use 'alignPositionAnimationCurve' instead.")
    Curve followAnimationCurve = Curves.fastOutSlowIn,
    @Deprecated("Use 'alignDirectionAnimationDuration' instead.")
    Duration turnAnimationDuration = const Duration(milliseconds: 50),
    @Deprecated("Use 'alignDirectionAnimationCurve' instead.")
    Curve turnAnimationCurve = Curves.easeInOut,
  })  : focalPoint = focalPoint ??
            FocalPoint(
              ratio: followScreenPoint ?? const Point<double>(0, 0),
              offset: followScreenPointOffset ?? const Point<double>(0, 0),
            ),
        alignPositionStream =
            alignPositionStream ?? followCurrentLocationStream,
        alignPositionOnUpdate = alignPositionOnUpdate ?? followOnLocationUpdate,
        alignPositionAnimationDuration =
            alignPositionAnimationDuration ?? followAnimationDuration,
        alignPositionAnimationCurve =
            alignPositionAnimationCurve ?? followAnimationCurve,
        alignDirectionStream =
            alignDirectionStream ?? turnHeadingUpLocationStream,
        alignDirectionOnUpdate = alignDirectionOnUpdate ?? turnOnHeadingUpdate,
        alignDirectionAnimationDuration =
            alignDirectionAnimationDuration ?? turnAnimationDuration,
        alignDirectionAnimationCurve =
            alignDirectionAnimationCurve ?? turnAnimationCurve;

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
        DiagnosticsProperty(
          'rotateAnimationDuration',
          rotateAnimationDuration,
        ),
      )
      ..add(DiagnosticsProperty('rotateAnimationCurve', rotateAnimationCurve))
      ..add(DiagnosticsProperty('indicators', indicators));
  }
}

class _CurrentLocationLayerState extends State<CurrentLocationLayer>
    with TickerProviderStateMixin {
  _Status _status = _Status.initialing;
  LocationMarkerPosition? _currentPosition;
  LocationMarkerHeading? _currentHeading;
  double? _followingZoom;

  late bool _isFirstLocationUpdate;
  late bool _isFirstHeadingUpdate;

  late StreamSubscription<LocationMarkerPosition?> _positionStreamSubscription;
  StreamSubscription<LocationMarkerHeading?>? _headingStreamSubscription;

  /// Subscription to a stream for following single that also include a zoom
  /// level.
  StreamSubscription<double?>? _alignPositionStreamSubscription;

  /// Subscription to a stream for single indicate turning the heading up.
  StreamSubscription<void>? _alignDirectionStreamSubscription;

  AnimationController? _moveMapAnimationController;
  AnimationController? _moveMarkerAnimationController;
  AnimationController? _rotateMapAnimationController;
  AnimationController? _rotateMarkerAnimationController;

  @override
  void initState() {
    super.initState();
    _isFirstLocationUpdate = true;
    _isFirstHeadingUpdate = true;
    _subscriptPositionStream();
  }

  @override
  void didUpdateWidget(CurrentLocationLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.positionStream != oldWidget.positionStream) {
      _positionStreamSubscription.cancel();
      _subscriptPositionStream();
    }
    if (_status == _Status.ready) {
      if (widget.headingStream != oldWidget.headingStream) {
        _headingStreamSubscription?.cancel();
        _subscriptHeadingStream();
      }
      if (widget.alignPositionStream != oldWidget.alignPositionStream) {
        _alignPositionStreamSubscription?.cancel();
        _subscriptAlignPositionStream();
      }
      if (widget.alignDirectionStream != oldWidget.alignDirectionStream) {
        _alignDirectionStreamSubscription?.cancel();
        _subscriptAlignDirectionStream();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _Status.initialing:
        return const SizedBox.shrink();
      case _Status.ready:
        if (_currentPosition != null) {
          return LocationMarkerLayer(
            position: _currentPosition!,
            heading: _currentHeading,
            style: widget.style,
          );
        } else {
          return const SizedBox.shrink();
        }
      case _Status.incorrectSetup:
        if (kDebugMode) {
          return SizedBox.expand(
            child: ColoredBox(
              color: Colors.red.withAlpha(0x80),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'LocationMarker plugin has not been setup correctly. '
                  'Please follow the instructions in the documentation.',
                  style: TextStyle(fontSize: 26),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      case _Status.permissionRequesting:
        if (widget.indicators.permissionRequesting != null) {
          return widget.indicators.permissionRequesting!;
        }
        if (kDebugMode) {
          return const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Location Access Permission Requesting\n'
                '(Debug Mode Only)',
                textAlign: TextAlign.right,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      case _Status.permissionDenied:
        if (widget.indicators.permissionDenied != null) {
          return widget.indicators.permissionDenied!;
        }
        if (kDebugMode) {
          return const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Location Access Permission Denied\n'
                '(Debug Mode Only)',
                textAlign: TextAlign.right,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      case _Status.serviceDisabled:
        if (widget.indicators.serviceDisabled != null) {
          return widget.indicators.serviceDisabled!;
        }
        if (kDebugMode) {
          return const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Location Service Disabled\n'
                '(Debug Mode Only)',
                textAlign: TextAlign.right,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _headingStreamSubscription?.cancel();
    _alignPositionStreamSubscription?.cancel();
    _alignDirectionStreamSubscription?.cancel();
    _moveMapAnimationController?.dispose();
    _moveMapAnimationController = null;
    _moveMarkerAnimationController?.dispose();
    _moveMarkerAnimationController = null;
    _rotateMapAnimationController?.dispose();
    _rotateMapAnimationController = null;
    _rotateMarkerAnimationController?.dispose();
    _rotateMarkerAnimationController = null;
    super.dispose();
  }

  void _subscriptPositionStream() {
    final positionStream = widget.positionStream ??
        const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();
    _positionStreamSubscription = positionStream.listen(
      (position) {
        if (!mounted) {
          return;
        }
        if (position == null) {
          if (_status != _Status.initialing) {
            setState(() {
              _status = _Status.initialing;
              _currentPosition = null;
            });
          }
        } else {
          if (_status != _Status.ready) {
            _subscriptHeadingStream();
            _subscriptAlignPositionStream();
            _subscriptAlignDirectionStream();
            setState(() {
              _status = _Status.ready;
            });
          }
          _moveMarker(position);

          bool alignPosition;
          switch (widget.alignPositionOnUpdate) {
            case AlignOnUpdate.always:
              alignPosition = true;
            case AlignOnUpdate.once:
              alignPosition = _isFirstLocationUpdate;
              _isFirstLocationUpdate = false;
            case AlignOnUpdate.never:
              alignPosition = false;
          }
          if (alignPosition) {
            _moveMap(
              position.latLng,
              _followingZoom,
            );
          }
        }
      },
      onError: (error) {
        switch (error) {
          case IncorrectSetupException _:
            setState(() => _status = _Status.incorrectSetup);
          case PermissionRequestingException _:
            setState(() => _status = _Status.permissionRequesting);
          case PermissionDeniedException _:
            setState(() => _status = _Status.permissionDenied);
          case ServiceDisabledException _:
            setState(() => _status = _Status.serviceDisabled);
        }
        _headingStreamSubscription?.cancel();
      },
    );
  }

  void _subscriptHeadingStream() {
    final headingStream = widget.headingStream ??
        const LocationMarkerDataStreamFactory().fromCompassHeadingStream();
    _headingStreamSubscription = headingStream.listen(
      (heading) {
        if (!mounted) {
          return;
        }
        if (heading == null) {
          if (_currentHeading != null) {
            setState(() => _currentHeading = null);
          }
        } else {
          if (_status == _Status.ready) {
            _rotateMarker(heading);

            bool alignDirection;
            switch (widget.alignDirectionOnUpdate) {
              case AlignOnUpdate.always:
                alignDirection = true;
              case AlignOnUpdate.once:
                alignDirection = _isFirstHeadingUpdate;
                _isFirstHeadingUpdate = false;
              case AlignOnUpdate.never:
                alignDirection = false;
            }
            if (alignDirection) {
              _rotateMap(-heading.heading % (2 * pi));
            }
          } else {
            _currentHeading = heading;
          }
        }
      },
      onError: (_) {
        if (_currentHeading != null) {
          setState(() => _currentHeading = null);
        }
      },
    );
  }

  void _subscriptAlignPositionStream() {
    if (_alignPositionStreamSubscription != null) {
      return;
    }
    _alignPositionStreamSubscription =
        widget.alignPositionStream?.listen((zoom) {
      if (!mounted) {
        return;
      }
      if (_currentPosition != null) {
        _followingZoom = zoom;
        _moveMap(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom,
        ).whenComplete(() => _followingZoom = null);
      }
    });
  }

  void _subscriptAlignDirectionStream() {
    if (_alignDirectionStreamSubscription != null) {
      return;
    }
    _alignDirectionStreamSubscription =
        widget.alignDirectionStream?.listen((_) {
      if (!mounted) {
        return;
      }
      if (_currentHeading != null) {
        _rotateMap(-_currentHeading!.heading % (2 * pi));
      }
    });
  }

  TickerFuture _moveMarker(LocationMarkerPosition position) {
    _moveMarkerAnimationController?.dispose();
    _moveMarkerAnimationController = AnimationController(
      duration: widget.moveAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _moveMarkerAnimationController!,
      curve: widget.moveAnimationCurve,
    );
    final positionTween = LocationMarkerPositionTween(
      begin: _currentPosition ?? position,
      end: position,
    );

    _moveMarkerAnimationController!.addListener(() {
      setState(() => _currentPosition = positionTween.evaluate(animation));
    });

    _moveMarkerAnimationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _moveMarkerAnimationController!.dispose();
        _moveMarkerAnimationController = null;
      }
    });

    return _moveMarkerAnimationController!.forward();
  }

  TickerFuture _moveMap(LatLng latLng, [double? zoom]) {
    final camera = MapCamera.of(context);
    final options = MapOptions.of(context);
    zoom ??= camera.zoom;

    final halfMapSize = camera.nonRotatedSize * 0.5;
    final projectedFocalPoint = widget.focalPoint.project(halfMapSize);

    final LatLng beginLatLng;
    if (projectedFocalPoint == halfMapSize) {
      beginLatLng = camera.center;
    } else {
      final crs = options.crs;
      final mapCenter = crs.latLngToPoint(camera.center, camera.zoom);
      final followPoint =
          camera.rotatePoint(mapCenter, mapCenter + projectedFocalPoint);
      beginLatLng = crs.pointToLatLng(followPoint, camera.zoom);
    }

    _moveMapAnimationController?.dispose();
    _moveMapAnimationController = AnimationController(
      duration: widget.alignPositionAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _moveMapAnimationController!,
      curve: widget.alignPositionAnimationCurve,
    );
    final latTween = Tween(
      begin: beginLatLng.latitude,
      end: latLng.latitude,
    );
    final lngTween = Tween(
      begin: beginLatLng.longitude,
      end: latLng.longitude,
    );
    final zoomTween = Tween(
      begin: camera.zoom,
      end: zoom,
    );

    _moveMapAnimationController!.addListener(() {
      final evaluatedLatLng = LatLng(
        latTween.evaluate(animation),
        lngTween.evaluate(animation),
      );
      final evaluatedZoom = zoomTween.evaluate(animation);

      final halfMapSize = camera.nonRotatedSize * 0.5;
      final projectedFocalPoint = widget.focalPoint.project(halfMapSize);

      if (projectedFocalPoint == halfMapSize) {
        MapController.of(context).move(
          evaluatedLatLng,
          evaluatedZoom,
        );
      } else {
        MapController.of(context).move(
          evaluatedLatLng,
          evaluatedZoom,
          offset: projectedFocalPoint.toOffset(),
        );
      }
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

  TickerFuture _rotateMarker(LocationMarkerHeading heading) {
    _rotateMarkerAnimationController?.dispose();
    _rotateMarkerAnimationController = AnimationController(
      duration: widget.rotateAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _rotateMarkerAnimationController!,
      curve: widget.rotateAnimationCurve,
    );
    final headingTween = LocationMarkerHeadingTween(
      begin: _currentHeading ?? heading,
      end: heading,
    );

    _rotateMarkerAnimationController!.addListener(() {
      if (_status == _Status.ready) {
        setState(() => _currentHeading = headingTween.evaluate(animation));
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
  }

  TickerFuture _rotateMap(double angle) {
    final camera = MapCamera.maybeOf(context)!;

    _rotateMapAnimationController?.dispose();
    if ((camera.rotationRad - angle).abs() < 0.006) {
      _rotateMapAnimationController = null;
      return TickerFuture.complete();
    }
    _rotateMapAnimationController = AnimationController(
      duration: widget.alignDirectionAnimationDuration,
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: _rotateMapAnimationController!,
      curve: widget.alignDirectionAnimationCurve,
    );
    final angleTween = RadiusTween(
      begin: camera.rotationRad,
      end: angle,
    );

    _rotateMapAnimationController!.addListener(() {
      final evaluatedAngle = angleTween.evaluate(animation) / pi * 180;

      final halfMapSize = camera.nonRotatedSize * 0.5;
      final projectedFocalPoint = widget.focalPoint.project(halfMapSize);

      if (projectedFocalPoint == halfMapSize) {
        MapController.of(context).rotate(evaluatedAngle);
      } else {
        MapController.of(context).rotateAroundPoint(
          evaluatedAngle,
          offset: projectedFocalPoint.toOffset(),
        );
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty('_status', _status))
      ..add(DiagnosticsProperty('_currentPosition', _currentPosition))
      ..add(DiagnosticsProperty('_currentHeading', _currentHeading))
      ..add(DoubleProperty('_followingZoom', _followingZoom))
      ..add(
        DiagnosticsProperty(
          '_isFirstLocationUpdate',
          _isFirstLocationUpdate,
        ),
      )
      ..add(DiagnosticsProperty('_isFirstHeadingUpdate', _isFirstHeadingUpdate))
      ..add(
        DiagnosticsProperty(
          '_positionStreamSubscription',
          _positionStreamSubscription,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_headingStreamSubscription',
          _headingStreamSubscription,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_alignPositionStreamSubscription',
          _alignPositionStreamSubscription,
        ),
      )
      ..add(
        DiagnosticsProperty(
          '_alignDirectionStreamSubscription',
          _alignDirectionStreamSubscription,
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

enum _Status {
  initialing,
  incorrectSetup,
  serviceDisabled,
  permissionRequesting,
  permissionDenied,
  ready,
}

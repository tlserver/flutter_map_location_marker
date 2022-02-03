import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/src/data.dart';

/// The tween that animates the current position of the device
class LocationMarkerPositionTween extends Tween<LocationMarkerPosition> {
  /// The tween that animates the current position of the device
  LocationMarkerPositionTween({
    required LocationMarkerPosition begin,
    required LocationMarkerPosition end,
  }) : super(begin: begin, end: end);

  @override
  LocationMarkerPosition lerp(double t) {
    final begin = super.begin!;
    final end = super.end!;
    return LocationMarkerPosition(
      latitude: _doubleLerp(begin.latitude, end.latitude, t),
      longitude: _doubleLerp(begin.longitude, end.longitude, t),
      accuracy: _doubleLerp(begin.accuracy, end.accuracy, t),
    );
  }
}

/// The tween of the heading of the device
class LocationMarkerHeadingTween extends Tween<LocationMarkerHeading> {
  /// The tween of the heading of the device
  LocationMarkerHeadingTween({
    required LocationMarkerHeading begin,
    required LocationMarkerHeading end,
  }) : super(begin: begin, end: end);

  @override
  LocationMarkerHeading lerp(double t) {
    final begin = super.begin!;
    final end = super.end!;
    return LocationMarkerHeading(
      heading: _radiusLerp(begin.heading, end.heading, t),
      accuracy: _radiusLerp(begin.accuracy, end.accuracy, t),
    );
  }
}

double _doubleLerp(double begin, double end, double t) =>
    begin + (end - begin) * t;

double _radiusLerp(double begin, double end, double t) {
  const twoPi = 2 * math.pi;
  final _begin = begin % twoPi;
  final _end = end % twoPi;

  final compareResult = (_end - _begin).abs().compareTo(math.pi);
  final crossZero = compareResult == 1 ||
      (compareResult == 0 && _begin != _end && _begin >= math.pi);
  if (crossZero) {
    double shift(double value) {
      return (value + math.pi) % twoPi;
    }

    return shift(_doubleLerp(shift(_begin), shift(_end), t));
  } else {
    return _doubleLerp(_begin, _end, t);
  }
}

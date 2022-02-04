import 'dart:math';

import 'package:flutter/material.dart';

import 'data.dart';

/// A linear interpolation between a beginning and ending value for
/// `LocationMarkerPosition`.
class LocationMarkerPositionTween extends Tween<LocationMarkerPosition> {
  /// Creates a tween.
  LocationMarkerPositionTween({
    required LocationMarkerPosition begin,
    required LocationMarkerPosition end,
  }) : super(
          begin: begin,
          end: end,
        );

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

/// A linear interpolation between a beginning and ending value for
/// `LocationMarkerHeadingTween`.
class LocationMarkerHeadingTween extends Tween<LocationMarkerHeading> {
  /// Creates a tween.
  LocationMarkerHeadingTween({
    required LocationMarkerHeading begin,
    required LocationMarkerHeading end,
  }) : super(
          begin: begin,
          end: end,
        );

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
  const twoPi = 2 * pi;
  // ignore: parameter_assignments
  begin = begin % twoPi;
  // ignore: parameter_assignments
  end = end % twoPi;

  final compareResult = (end - begin).abs().compareTo(pi);
  final crossZero =
      compareResult == 1 || (compareResult == 0 && begin != end && begin >= pi);
  if (crossZero) {
    double shift(double value) {
      return (value + pi) % twoPi;
    }

    return shift(_doubleLerp(shift(begin), shift(end), t));
  } else {
    return _doubleLerp(begin, end, t);
  }
}

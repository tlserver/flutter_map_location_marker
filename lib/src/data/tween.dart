import 'dart:math';

import 'package:flutter/material.dart';

import 'data.dart';

/// A linear interpolation between a beginning and ending value for
/// `LocationMarkerPosition`.
class LocationMarkerPositionTween extends Tween<LocationMarkerPosition> {
  /// Creates a tween.
  LocationMarkerPositionTween({
    required super.begin,
    required super.end,
  });

  @override
  LocationMarkerPosition lerp(double t) {
    final begin = this.begin!;
    final end = this.end!;
    return LocationMarkerPosition(
      latitude: _doubleLerp(begin.latitude, end.latitude, t),
      longitude: _doubleLerp(begin.longitude, end.longitude, t),
      accuracy: _doubleLerp(begin.accuracy, end.accuracy, t),
    );
  }
}

/// A linear interpolation between a beginning and ending value for
/// `LocationMarkerHeading`.
class LocationMarkerHeadingTween extends Tween<LocationMarkerHeading> {
  /// Creates a tween.
  LocationMarkerHeadingTween({
    required super.begin,
    required super.end,
  });

  @override
  LocationMarkerHeading lerp(double t) {
    final begin = this.begin!;
    final end = this.end!;
    return LocationMarkerHeading(
      heading: _radiusLerp(begin.heading, end.heading, t),
      accuracy: _radiusLerp(begin.accuracy, end.accuracy, t),
    );
  }
}

/// A linear interpolation between a beginning and ending value for degree
/// value. This value turn for both clockwise or anti-clockwise according to the
/// shorter direction.
class DegreeTween extends Tween<double> {
  /// Creates a tween.
  DegreeTween({
    required double begin,
    required double end,
  }) : super(
          begin: begin % 360,
          end: end % 360,
        );

  @override
  double lerp(double t) => _degreeLerp(begin!, end!, t);
}

/// A linear interpolation between a beginning and ending value for radius
/// value. This value turn for both clockwise or anti-clockwise according to the
/// shorter direction.
class RadiusTween extends Tween<double> {
  /// Creates a tween.
  RadiusTween({
    required double begin,
    required double end,
  }) : super(
          begin: begin % (2 * pi),
          end: end % (2 * pi),
        );

  @override
  double lerp(double t) => _radiusLerp(begin!, end!, t);
}

double _doubleLerp(double begin, double end, double t) =>
    begin + (end - begin) * t;

double _circularLerp(double begin, double end, double t, double oneCircle) {
  final halfCircle = oneCircle / 2;
  // ignore: parameter_assignments
  begin = begin % oneCircle;
  // ignore: parameter_assignments
  end = end % oneCircle;

  final compareResult = (end - begin).abs().compareTo(halfCircle);
  final crossZero = compareResult == 1 ||
      (compareResult == 0 && begin != end && begin >= halfCircle);
  if (crossZero) {
    double opposite(double value) => (value + halfCircle) % oneCircle;

    return opposite(_doubleLerp(opposite(begin), opposite(end), t));
  } else {
    return _doubleLerp(begin, end, t);
  }
}

double _degreeLerp(double begin, double end, double t) =>
    _circularLerp(begin, end, t, 360);

double _radiusLerp(double begin, double end, double t) =>
    _circularLerp(begin, end, t, 2 * pi);

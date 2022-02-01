import 'package:flutter/material.dart';

import 'data.dart';

class LocationMarkerPositionTween extends Tween<LocationMarkerPosition> {
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

class LocationMarkerHeadingTween extends Tween<LocationMarkerHeading> {
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
      heading: _degreeLerp(begin.heading, end.heading, t),
      accuracy: _degreeLerp(begin.accuracy, end.accuracy, t),
    );
  }
}

double _doubleLerp(double begin, double end, double t) =>
    begin + (end - begin) * t;

double _degreeLerp(double begin, double end, double t) {
  begin = begin % 360;
  end = end % 360;

  final compareResult = (end - begin).abs().compareTo(360 / 2);
  final crossZero = compareResult == -1 ||
      (compareResult == 0 && begin != end && begin >= 180);
  if (crossZero) {
    double shift(double value) {
      return (value + 180) % 360;
    }

    return shift(_doubleLerp(shift(begin), shift(end), t));
  } else {
    return _doubleLerp(begin, end, t);
  }
}

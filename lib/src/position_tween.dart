import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PositionTween extends Tween<Position> {
  PositionTween({
    @required Position begin,
    @required Position end,
  }) : super(
          begin: begin,
          end: end,
        );

  @override
  Position lerp(double t) {
    assert(begin != null);
    assert(end != null);
    return Position(
      latitude: _doubleLerp(begin.latitude, end.latitude, t),
      longitude: _doubleLerp(begin.longitude, end.longitude, t),
      timestamp: _timestampLerp(begin.timestamp, end.timestamp, t),
      isMocked: _nearest(begin.isMocked, end.isMocked, t),
      accuracy: _doubleLerp(begin.accuracy, end.accuracy, t),
      altitude: _doubleLerp(begin.altitude, end.altitude, t),
      heading: _degreeLerp(begin.heading, end.heading, t),
      speed: _doubleLerp(begin.speed, end.speed, t),
      speedAccuracy: _doubleLerp(begin.speedAccuracy, end.speedAccuracy, t),
    );
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

  DateTime _timestampLerp(DateTime begin, DateTime end, double t) {
    if (begin != null && end != null) {
      return begin.add(end.difference(begin) * t);
    } else {
      return _nearest(begin, end, t);
    }
  }

  T _nearest<T>(T begin, T end, double t) {
    return t < 0.5 ? begin : end;
  }
}

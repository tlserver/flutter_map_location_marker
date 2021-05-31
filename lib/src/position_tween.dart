import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PositionTween extends Tween<Position> {
  PositionTween({
    required Position? begin,
    required Position? end,
  }) : super(
          begin: begin,
          end: end,
        );

  @override
  Position lerp(double t) {
    assert(begin != null);
    assert(end != null);
    return Position(
      latitude: doubleLerp(begin!.latitude, end!.latitude, t),
      longitude: doubleLerp(begin!.longitude, end!.longitude, t),
      timestamp:
          begin!.timestamp!.add(end!.timestamp!.difference(begin!.timestamp!) * t),
      isMocked: t < 0.5 ? begin!.isMocked : end!.isMocked,
      accuracy: doubleLerp(begin!.accuracy, end!.accuracy, t),
      altitude: doubleLerp(begin!.altitude, end!.altitude, t),
      heading: degreeLerp(begin!.heading, end!.heading, t),
      speed: doubleLerp(begin!.speed, end!.speed, t),
      speedAccuracy: doubleLerp(begin!.speedAccuracy, end!.speedAccuracy, t),
    );
  }

  double doubleLerp(double begin, double end, double t) =>
      begin + (end - begin) * t;

  double degreeLerp(double begin, double end, double t) {
    begin = begin % 360;
    end = end % 360;

    final compareResult = (end - begin).abs().compareTo(360 / 2);
    final crossZero = compareResult == -1 ||
        (compareResult == 0 && begin != end && begin >= 180);
    if (crossZero) {
      double shift(double value) {
        return (value + 180) % 360;
      }

      return shift(doubleLerp(shift(begin), shift(end), t));
    } else {
      return doubleLerp(begin, end, t);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../data/data.dart';
import '../data/tween.dart';
import '../options/style.dart';
import 'location_marker_layer.dart';

/// A layer for location marker in [FlutterMap] with animation.
class AnimatedLocationMarkerLayer extends StatelessWidget {
  /// A position with accuracy.
  final LocationMarkerPosition position;

  /// A angle with accuracy.
  final LocationMarkerHeading? heading;

  /// The style to use for this location marker.
  final LocationMarkerStyle style;

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

  /// Create a AnimatedLocationMarkerLayer.
  const AnimatedLocationMarkerLayer({
    super.key,
    required this.position,
    this.heading,
    this.style = const LocationMarkerStyle(),
    this.moveAnimationDuration = const Duration(milliseconds: 200),
    this.moveAnimationCurve = Curves.fastOutSlowIn,
    this.rotateAnimationDuration = const Duration(milliseconds: 50),
    this.rotateAnimationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: LocationMarkerPositionTween(
        begin: position,
        end: position,
      ),
      curve: moveAnimationCurve,
      duration: moveAnimationDuration,
      builder: (
        BuildContext context,
        LocationMarkerPosition position,
        Widget? child,
      ) {
        if (heading != null) {
          return TweenAnimationBuilder(
            tween: LocationMarkerHeadingTween(
              begin: heading,
              end: heading,
            ),
            curve: rotateAnimationCurve,
            duration: rotateAnimationDuration,
            builder: (
              BuildContext context,
              LocationMarkerHeading heading,
              Widget? child,
            ) {
              return LocationMarkerLayer(
                position: position,
                heading: heading,
                style: style,
              );
            },
          );
        } else {
          return LocationMarkerLayer(
            position: position,
            style: style,
          );
        }
      },
    );
  }
}

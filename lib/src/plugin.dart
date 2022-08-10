import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'center_on_location_update.dart';
import 'layer.dart';
import 'layer_options.dart';
import 'turn_on_heading_update.dart';

/// A plugin that should be registered in [FlutterMap] in order to render
/// [LocationMarkerLayer].
class LocationMarkerPlugin {
  /// The event stream for centering current location. Add a zoom level into
  /// this stream to center the current location at the provided zoom level or a
  /// null if the zoom level should be unchanged. Default to null.
  ///
  /// For more details, see
  /// [CenterFabExample](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/center_fab_example.dart).
  final Stream<double?>? centerCurrentLocationStream;

  /// The event stream for turning heading up. Default to null.
  final Stream<void>? turnHeadingUpLocationStream;

  /// When should the plugin center the current location to the map. Default to
  /// [CenterOnLocationUpdate.never].
  final CenterOnLocationUpdate centerOnLocationUpdate;

  /// When should the plugin center the current location to the map. Default to
  /// [TurnOnHeadingUpdate.never].
  final TurnOnHeadingUpdate turnOnHeadingUpdate;

  /// The duration of the animation of centering the current location. Default
  /// to 200ms.
  final Duration centerAnimationDuration;

  /// The curve of the animation of centering the current location. Default to
  /// [Curves.fastOutSlowIn].
  final Curve centerAnimationCurve;

  /// The duration of the animation of turn the current location. Default to
  /// 200ms.
  final Duration turnAnimationDuration;

  /// The curve of the animation of turn the current location. Default to
  /// [Curves.easeInOut].
  final Curve turnAnimationCurve;

  /// Create a LocationMarkerPlugin.
  const LocationMarkerPlugin({
    this.centerCurrentLocationStream,
    this.turnHeadingUpLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.turnOnHeadingUpdate = TurnOnHeadingUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 200),
    this.centerAnimationCurve = Curves.fastOutSlowIn,
    this.turnAnimationDuration = const Duration(milliseconds: 200),
    this.turnAnimationCurve = Curves.easeInOut,
  });

}

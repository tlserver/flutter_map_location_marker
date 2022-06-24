import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'center_on_location_update.dart';
import 'layer.dart';
import 'layer_options.dart';
import 'turn_on_heading_update.dart';

/// A plugin that should be registered in [FlutterMap] in order to render
/// [LocationMarkerLayer].
class LocationMarkerPlugin implements MapPlugin {
  /// The event stream for centering current location. Add a zoom level into
  /// this stream to center the current location at the provided zoom level or a
  /// null if the zoom level should be unchanged.
  ///
  /// For more details, see
  /// [CenterFabExample](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/center_fab_example.dart).
  final Stream<double?>? centerCurrentLocationStream;

  /// The event stream for turning heading up.
  final Stream<void>? turnHeadingUpLocationStream;

  /// When should the plugin center the current location to the map.
  final CenterOnLocationUpdate centerOnLocationUpdate;

  /// When should the plugin center the current location to the map.
  final TurnOnHeadingUpdate turnOnHeadingUpdate;

  /// The duration of the animation of centering the current location.
  final Duration centerAnimationDuration;

  /// The duration of the animation of turn the current location.
  final Duration turnAnimationDuration;

  /// The curve of the animation of centering the current location.
  final Curve centerAnimationCurve;

  /// The curve of the animation of turn the current location.
  final Curve turnAnimationCurve;

  /// Create a LocationMarkerPlugin.
  const LocationMarkerPlugin({
    this.centerCurrentLocationStream,
    this.turnHeadingUpLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.turnOnHeadingUpdate = TurnOnHeadingUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 200),
    this.turnAnimationDuration = const Duration(milliseconds: 200),
    this.centerAnimationCurve = Curves.fastOutSlowIn,
    this.turnAnimationCurve = Curves.easeInOut,
  });

  @override
  Widget createLayer(
    LayerOptions options,
    MapState mapState,
    Stream<void> stream,
  ) {
    return LocationMarkerLayer(
      this,
      options as LocationMarkerLayerOptions,
      mapState,
      stream,
    );
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is LocationMarkerLayerOptions;
  }
}

// ignore_for_file: prefer_void_to_null

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/src/center_on_location_update.dart';
import 'package:flutter_map_location_marker/src/layer.dart';
import 'package:flutter_map_location_marker/src/layer_options.dart';

/// The plugin for location marker to be put in [FlutterMap]
class LocationMarkerPlugin implements MapPlugin {
  /// The plugin for location marker to be put in [FlutterMap]
  const LocationMarkerPlugin({
    this.centerCurrentLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 500),
  });

  /// The event stream for center current location. Add a zoom level into this
  /// stream to center the current location at the provided zoom level or a null
  /// if the zoom level should be unchanged.
  ///
  /// For more details, see CenterFabExample.
  final Stream<double?>? centerCurrentLocationStream;

  /// When should the plugin center the current location to the map.
  final CenterOnLocationUpdate centerOnLocationUpdate;

  /// The duration of the animation of centering the current location.
  final Duration centerAnimationDuration;

  @override
  Widget createLayer(
    LayerOptions options,
    MapState mapState,
    Stream<Null> stream,
  ) =>
      LocationMarkerLayer(
        this,
        options as LocationMarkerLayerOptions,
        mapState,
        stream,
      );

  @override
  bool supportsLayer(LayerOptions options) =>
      options is LocationMarkerLayerOptions;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'center_on_location_update.dart';
import 'layer.dart';
import 'layer_options.dart';

class LocationMarkerPlugin implements MapPlugin {
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

  const LocationMarkerPlugin({
    this.centerCurrentLocationStream,
    this.centerOnLocationUpdate = CenterOnLocationUpdate.never,
    this.centerAnimationDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    return LocationMarkerLayer(
        this, options as LocationMarkerLayerOptions, mapState, stream);
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is LocationMarkerLayerOptions;
  }
}

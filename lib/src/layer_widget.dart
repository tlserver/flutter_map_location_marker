import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'layer.dart';
import 'layer_options.dart';
import 'plugin.dart';

/// A [Widget] that build a [LocationMarkerLayer].
class LocationMarkerLayerWidget extends StatelessWidget {
  /// A [LocationMarkerPlugin] instance. Default to [LocationMarkerPlugin] with
  /// default parameters.
  final LocationMarkerPlugin plugin;

  /// Options for drawing this layer. Default to null.
  final LocationMarkerLayerOptions? options;

  /// Create a LocationMarkerLayerWidget.
  LocationMarkerLayerWidget({
    super.key,
    this.plugin = const LocationMarkerPlugin(),
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context)!;
    return LocationMarkerLayer(plugin, options, mapState);
  }
}

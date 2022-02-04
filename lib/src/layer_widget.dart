import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'layer.dart';
import 'layer_options.dart';
import 'plugin.dart';

/// A [Widget] that build a [LocationMarkerLayer].
class LocationMarkerLayerWidget extends StatelessWidget {
  /// A [LocationMarkerPlugin] instance.
  final LocationMarkerPlugin plugin;

  /// Options for drawing this layer.
  final LocationMarkerLayerOptions? options;

  /// Create a LocationMarkerLayerWidget.
  LocationMarkerLayerWidget({
    this.plugin = const LocationMarkerPlugin(),
    this.options,
  }) : super(
          key: options?.key,
        );

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return LocationMarkerLayer(plugin, options, mapState, mapState.onMoved);
  }
}

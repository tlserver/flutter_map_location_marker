import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'layer.dart';
import 'layer_options.dart';
import 'plugin.dart';

class LocationMarkerLayerWidget extends StatelessWidget {
  final LocationMarkerPlugin plugin;
  final LocationMarkerLayerOptions? options;

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

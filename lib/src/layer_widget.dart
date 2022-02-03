import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/src/layer.dart';
import 'package:flutter_map_location_marker/src/layer_options.dart';
import 'package:flutter_map_location_marker/src/plugin.dart';

/// The [Widget] that [FlutterMap] will use
class LocationMarkerLayerWidget extends StatelessWidget {
  /// The [Widget] that [FlutterMap] will use
  LocationMarkerLayerWidget({
    this.plugin = const LocationMarkerPlugin(),
    this.options,
  }) : super(key: options?.key);

  // ignore: public_member_api_docs
  final LocationMarkerPlugin plugin;
  // ignore: public_member_api_docs
  final LocationMarkerLayerOptions? options;

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return LocationMarkerLayer(plugin, options, mapState, mapState.onMoved);
  }
}

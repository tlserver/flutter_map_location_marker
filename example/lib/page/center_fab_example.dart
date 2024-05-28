import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class CenterFabExample extends StatefulWidget {
  @override
  _CenterFabExampleState createState() => _CenterFabExampleState();
}

class _CenterFabExampleState extends State<CenterFabExample> {
  late AlignOnUpdate _alignPositionOnUpdate;
  late final StreamController<double?> _alignPositionStreamController;

  @override
  void initState() {
    super.initState();
    _alignPositionOnUpdate = AlignOnUpdate.always;
    _alignPositionStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _alignPositionStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Center FAB Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(0, 0),
          initialZoom: 1,
          minZoom: 0,
          maxZoom: 19,
          // Stop aligning the location marker to the center of the map widget
          // if user interacted with the map.
          onPositionChanged: (MapCamera camera, bool hasGesture) {
            if (hasGesture && _alignPositionOnUpdate != AlignOnUpdate.never) {
              setState(
                () => _alignPositionOnUpdate = AlignOnUpdate.never,
              );
            }
          },
        ),
        // ignore: sort_child_properties_last
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 19,
          ),
          CurrentLocationLayer(
            alignPositionStream: _alignPositionStreamController.stream,
            alignPositionOnUpdate: _alignPositionOnUpdate,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () {
                  // Align the location marker to the center of the map widget
                  // on location update until user interact with the map.
                  setState(
                    () => _alignPositionOnUpdate = AlignOnUpdate.always,
                  );
                  // Align the location marker to the center of the map widget
                  // and zoom the map to level 18.
                  _alignPositionStreamController.add(18);
                },
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

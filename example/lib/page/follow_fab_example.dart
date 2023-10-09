import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class FollowFabExample extends StatefulWidget {
  @override
  _FollowFabExampleState createState() => _FollowFabExampleState();
}

class _FollowFabExampleState extends State<FollowFabExample> {
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follow FAB Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(0, 0),
          initialZoom: 1,
          minZoom: 0,
          maxZoom: 19,
          // Stop following the location marker on the map if user interacted with the map.
          onPositionChanged: (MapPosition position, bool hasGesture) {
            if (hasGesture &&
                _followOnLocationUpdate != FollowOnLocationUpdate.never) {
              setState(
                () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
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
            followCurrentLocationStream:
                _followCurrentLocationStreamController.stream,
            followOnLocationUpdate: _followOnLocationUpdate,
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Follow the location marker on the map when location updated until user interact with the map.
                setState(
                  () => _followOnLocationUpdate = FollowOnLocationUpdate.always,
                );
                // Follow the location marker on the map and zoom the map to level 18.
                _followCurrentLocationStreamController.add(18);
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

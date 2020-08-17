import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong/latlong.dart';

class CenterFabExample extends StatefulWidget {
  @override
  _CenterFabExampleState createState() => _CenterFabExampleState();
}

class _CenterFabExampleState extends State<CenterFabExample> {
  CenterOnLocationUpdate _centerOnLocationUpdate;
  StreamController<double> _centerCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double>();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
              center: LatLng(0, 0),
              zoom: 1,
              maxZoom: 19,
              plugins: [
                LocationMarkerPlugin(
                  centerCurrentLocationStream: _centerCurrentLocationStreamController.stream,
                  centerOnLocationUpdate: _centerOnLocationUpdate,
                ),
              ],
              // Stop centering the location marker on the map if user interacted with the map.
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (hasGesture) {
                  setState(() => _centerOnLocationUpdate = CenterOnLocationUpdate.never);
                }
              }),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              maxZoom: 19,
            ),
            LocationMarkerLayerOptions(),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {
              // Automatically center the location marker on the map when location updated until user interact with the map.
              setState(() => _centerOnLocationUpdate = CenterOnLocationUpdate.always);
              // Center the location marker on the map and zoom the map to level 18.
              _centerCurrentLocationStreamController.add(18);
            },
            child: Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

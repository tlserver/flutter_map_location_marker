import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

// A demo for a custom position and heading stream. In this example, the
// location marker is controlled by a joystick instead of the device sensor.
// This example provide same behavior as Joystick Example.
class CustomStreamExample extends StatefulWidget {
  @override
  _CustomStreamExampleState createState() => _CustomStreamExampleState();
}

class _CustomStreamExampleState extends State<CustomStreamExample> {
  late final StreamController<LocationMarkerPosition> positionStreamController;
  late final StreamController<LocationMarkerHeading> headingStreamController;
  double _currentLat = 0;
  double _currentLng = 0;

  @override
  void initState() {
    super.initState();
    positionStreamController = StreamController()
      ..add(
        LocationMarkerPosition(
          latitude: _currentLat,
          longitude: _currentLng,
          accuracy: 0,
        ),
      );
    headingStreamController = StreamController()
      ..add(
        LocationMarkerHeading(
          heading: 0,
          accuracy: pi * 0.2,
        ),
      );
  }

  @override
  void dispose() {
    positionStreamController.close();
    headingStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Stream Example'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(0, 0),
              zoom: 1,
              maxZoom: 19,
            ),
            // ignore: sort_child_properties_last
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName:
                    'net.tlserver6y.flutter_map_location_marker.example',
                maxZoom: 19,
              ),
              CurrentLocationLayer(
                positionStream: positionStreamController.stream,
                headingStream: headingStreamController.stream,
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Joystick(
              listener: (details) {
                _currentLat -= details.y;
                _currentLat = _currentLat.clamp(-90, 90);
                _currentLng += details.x;
                _currentLng = _currentLng.clamp(-180, 180);
                positionStreamController.add(
                  LocationMarkerPosition(
                    latitude: _currentLat,
                    longitude: _currentLng,
                    accuracy: 0,
                  ),
                );
                if (details.x != 0 || details.y != 0) {
                  headingStreamController.add(
                    LocationMarkerHeading(
                      heading: atan2(details.y, details.x) + pi * 0.5,
                      accuracy: pi * 0.2,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

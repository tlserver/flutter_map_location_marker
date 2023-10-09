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
  late final StreamController<LocationMarkerPosition> _positionStreamController;
  late final StreamController<LocationMarkerHeading> _headingStreamController;
  double _currentLat = 0;
  double _currentLng = 0;

  @override
  void initState() {
    super.initState();
    _positionStreamController = StreamController()
      ..add(
        LocationMarkerPosition(
          latitude: _currentLat,
          longitude: _currentLng,
          accuracy: 0,
        ),
      );
    _headingStreamController = StreamController()
      ..add(
        LocationMarkerHeading(
          heading: 0,
          accuracy: pi * 0.2,
        ),
      );
  }

  @override
  void dispose() {
    _positionStreamController.close();
    _headingStreamController.close();
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
            options: const MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 1,
              minZoom: 0,
              maxZoom: 19,
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
                positionStream: _positionStreamController.stream,
                headingStream: _headingStreamController.stream,
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Joystick(
              listener: (details) {
                _currentLat -= details.y;
                _currentLat = _currentLat.clamp(-85, 85);
                _currentLng += details.x;
                _currentLng = _currentLng.clamp(-180, 180);
                _positionStreamController.add(
                  LocationMarkerPosition(
                    latitude: _currentLat,
                    longitude: _currentLng,
                    accuracy: 0,
                  ),
                );
                if (details.x != 0 || details.y != 0) {
                  _headingStreamController.add(
                    LocationMarkerHeading(
                      heading:
                          (atan2(details.y, details.x) + pi * 0.5) % (pi * 2),
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

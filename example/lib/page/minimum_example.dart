import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class MinimumExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimum Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: const LatLng(0, 0),
          zoom: 1,
          minZoom: 0,
          maxZoom: 19,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 19,
          ),
          CurrentLocationLayer(),
        ],
      ),
    );
  }
}

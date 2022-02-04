import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeolocatorSettingsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(0, 0),
        zoom: 1,
        maxZoom: 19,
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            maxZoom: 19,
          ),
        ),
        LocationMarkerLayerWidget(
          options: LocationMarkerLayerOptions(
            positionStream: const LocationMarkerDataStreamFactory()
                .geolocatorPositionStream(
              stream: Geolocator.getPositionStream(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.medium,
                  distanceFilter: 50,
                  timeLimit: Duration(minutes: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

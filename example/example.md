```dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(
    MaterialApp(
      home: MinimumExample(),
    ),
  );
}

class MinimumExample extends StatelessWidget {
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
        LocationMarkerLayerWidget(),
      ],
    );
  }
}
```

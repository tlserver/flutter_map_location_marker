import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class SelectableDistanceFilterExample extends StatefulWidget {
  @override
  State<SelectableDistanceFilterExample> createState() =>
      _SelectableDistanceFilterExampleState();
}

class _SelectableDistanceFilterExampleState
    extends State<SelectableDistanceFilterExample> {
  static const distanceFilters = [0, 5, 10, 30, 50];
  int _selectedIndex = 0;

  late StreamController<LocationMarkerPosition> positionStream;
  late StreamSubscription<LocationMarkerPosition?> streamSubscription;

  @override
  void initState() {
    super.initState();
    positionStream = StreamController();
    _subscriptPositionStream();
  }

  @override
  void dispose() {
    positionStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
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
              positionStream: positionStream.stream,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Distance Filter:'),
                  ToggleButtons(
                    children: distanceFilters
                        .map((distance) => Text(distance.toString()))
                        .toList(growable: false),
                    isSelected: List.generate(
                      distanceFilters.length,
                      (index) => index == _selectedIndex,
                      growable: false,
                    ),
                    onPressed: (index) {
                      setState(() => _selectedIndex = index);
                      streamSubscription.cancel();
                      _subscriptPositionStream();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _subscriptPositionStream() {
    streamSubscription = const LocationMarkerDataStreamFactory()
        .geolocatorPositionStream(
      stream: Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          distanceFilter: distanceFilters[_selectedIndex],
        ),
      ),
    )
        .listen((position) {
      positionStream.add(position);
    });
  }
}

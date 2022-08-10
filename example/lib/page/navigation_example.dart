import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class NavigationExample extends StatefulWidget {
  @override
  _NavigationExampleState createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  late bool navigationMode;
  late int pointerCount;
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late TurnOnHeadingUpdate _turnOnHeadingUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;
  late StreamController<void> _turnHeadingUpStreamController;

  @override
  void initState() {
    super.initState();
    navigationMode = false;
    pointerCount = 0;
    _centerOnLocationUpdate = CenterOnLocationUpdate.never;
    _turnOnHeadingUpdate = TurnOnHeadingUpdate.never;
    _centerCurrentLocationStreamController = StreamController<double?>();
    _turnHeadingUpStreamController = StreamController<void>();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(0, 0),
          zoom: 1,
          maxZoom: 19,
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerUp,
        ),
        // ignore: sort_child_properties_last
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 19,
          ),
          LocationMarkerLayerWidget(
            plugin: LocationMarkerPlugin(
              centerCurrentLocationStream:
                  _centerCurrentLocationStreamController.stream,
              turnHeadingUpLocationStream:
                  _turnHeadingUpStreamController.stream,
              centerOnLocationUpdate: _centerOnLocationUpdate,
              turnOnHeadingUpdate: _turnOnHeadingUpdate,
            ),
            options: LocationMarkerLayerOptions(
              marker: const DefaultLocationMarker(
                child: Icon(
                  Icons.navigation,
                  color: Colors.white,
                ),
              ),
              markerSize: const Size(40, 40),
              markerDirection: MarkerDirection.heading,
            ),
          ),
        ],
        nonRotatedChildren: [
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: navigationMode ? Colors.blue : Colors.grey,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(
                  () {
                    navigationMode = !navigationMode;
                    _centerOnLocationUpdate = navigationMode
                        ? CenterOnLocationUpdate.always
                        : CenterOnLocationUpdate.never;
                    _turnOnHeadingUpdate = navigationMode
                        ? TurnOnHeadingUpdate.always
                        : TurnOnHeadingUpdate.never;
                  },
                );
                if (navigationMode) {
                  _centerCurrentLocationStreamController.add(18);
                  _turnHeadingUpStreamController.add(null);
                }
              },
              child: const Icon(
                Icons.navigation_outlined,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Disable center and turn temporarily when user is manipulating the map.
  void _onPointerDown(e, l) {
    pointerCount++;
    setState(() {
      _centerOnLocationUpdate = CenterOnLocationUpdate.never;
      _turnOnHeadingUpdate = TurnOnHeadingUpdate.never;
    });
  }

  // Enable center and turn again when user end manipulation.
  void _onPointerUp(e, l) {
    if (--pointerCount == 0 && navigationMode) {
      setState(() {
        _centerOnLocationUpdate = CenterOnLocationUpdate.always;
        _turnOnHeadingUpdate = TurnOnHeadingUpdate.always;
      });
      _centerCurrentLocationStreamController.add(18);
      _turnHeadingUpStreamController.add(null);
    }
  }
}

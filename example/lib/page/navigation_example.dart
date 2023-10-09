import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class NavigationExample extends StatefulWidget {
  @override
  _NavigationExampleState createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  late bool _navigationMode;
  late int _pointerCount;
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late TurnOnHeadingUpdate _turnOnHeadingUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  late StreamController<void> _turnHeadingUpStreamController;

  @override
  void initState() {
    super.initState();
    _navigationMode = false;
    _pointerCount = 0;
    _followOnLocationUpdate = FollowOnLocationUpdate.never;
    _turnOnHeadingUpdate = TurnOnHeadingUpdate.never;
    _followCurrentLocationStreamController = StreamController<double?>();
    _turnHeadingUpStreamController = StreamController<void>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    _turnHeadingUpStreamController.close();
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
          initialCenter: const LatLng(0, 0),
          initialZoom: 1,
          minZoom: 0,
          maxZoom: 19,
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerUp,
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
            followScreenPoint: const Point(0.0, 1.0),
            followScreenPointOffset: const Point(0.0, -60.0),
            followCurrentLocationStream:
                _followCurrentLocationStreamController.stream,
            turnHeadingUpLocationStream: _turnHeadingUpStreamController.stream,
            followOnLocationUpdate: _followOnLocationUpdate,
            turnOnHeadingUpdate: _turnOnHeadingUpdate,
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(
                  Icons.navigation,
                  color: Colors.white,
                ),
              ),
              markerSize: Size(40, 40),
              markerDirection: MarkerDirection.heading,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: _navigationMode ? Colors.blue : Colors.grey,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(
                  () {
                    _navigationMode = !_navigationMode;
                    _followOnLocationUpdate = _navigationMode
                        ? FollowOnLocationUpdate.always
                        : FollowOnLocationUpdate.never;
                    _turnOnHeadingUpdate = _navigationMode
                        ? TurnOnHeadingUpdate.always
                        : TurnOnHeadingUpdate.never;
                  },
                );
                if (_navigationMode) {
                  _followCurrentLocationStreamController.add(18);
                  _turnHeadingUpStreamController.add(null);
                }
              },
              child: const Icon(
                Icons.navigation_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Disable follow and turn temporarily when user is manipulating the map.
  void _onPointerDown(e, l) {
    _pointerCount++;
    setState(() {
      _followOnLocationUpdate = FollowOnLocationUpdate.never;
      _turnOnHeadingUpdate = TurnOnHeadingUpdate.never;
    });
  }

  // Enable follow and turn again when user end manipulation.
  void _onPointerUp(e, l) {
    if (--_pointerCount == 0 && _navigationMode) {
      setState(() {
        _followOnLocationUpdate = FollowOnLocationUpdate.always;
        _turnOnHeadingUpdate = TurnOnHeadingUpdate.always;
      });
      _followCurrentLocationStreamController.add(18);
      _turnHeadingUpStreamController.add(null);
    }
  }
}

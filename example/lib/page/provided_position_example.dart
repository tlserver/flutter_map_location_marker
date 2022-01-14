import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class ProvidedPositionExample extends StatefulWidget {
  @override
  _ProvidedPositionExample createState() => _ProvidedPositionExample();
}

class _ProvidedPositionExample extends State<ProvidedPositionExample> {
  bool _locationPermissionsGranted = false;
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _position;
  LocationSettings _locationSettings =
      LocationSettingsPanel.defaultLocationSettings;

  @override
  void initState() {
    super.initState();

    _askForLocationPermission().then((granted) {
      if (granted) {
        _createPositionStream(_locationSettings);
        return null;
      }

      return _showLocationPermissionDeniedDialog();
    });
  }

  @override
  void dispose() {
    _destroyPositionStream();
    return super.dispose();
  }

  Future<bool> _askForLocationPermission() async {
    try {
      final permissions = await Geolocator.requestPermission();

      setState(() {
        _locationPermissionsGranted =
            permissions == LocationPermission.always ||
                permissions == LocationPermission.whileInUse;
      });

      return _locationPermissionsGranted;
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _locationPermissionsGranted = false;
      });

      return _locationPermissionsGranted;
    }
  }

  Future<void> _showLocationPermissionDeniedDialog() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Location access denied.'),
              content: const Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Please turn on location access.')),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'))
              ],
            ));
  }

  void _createPositionStream(LocationSettings locationSettings) {
    if (!_locationPermissionsGranted) {
      return;
    }

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen(_handlePositionChange);
  }

  FutureOr<void> _destroyPositionStream() {
    return _positionStreamSubscription?.cancel();
  }

  void _handlePositionChange(Position position) {
    setState(() {
      _position = position;
    });
  }

  Future<void> _handleLocationSettingsChange(
      LocationSettings locationSettings) async {
    await _destroyPositionStream();
    _createPositionStream(locationSettings);
    setState(() {
      _locationSettings = locationSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Stack(children: [
      ProvidedPositionExampleMap(
        locationPermissionsGranted: _locationPermissionsGranted,
        position: _position,
      ),
      Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: LocationSettingsPanel.height,
            width: MediaQuery.of(context).size.width,
            child: LocationSettingsPanel(
              value: _locationSettings,
              disabled: _locationPermissionsGranted,
              onLocationSettingsChanged: _handleLocationSettingsChange,
            ),
          )),
      Positioned(
        top: LocationSettingsPanel.height,
        child: SizedBox(
          height: CurrentLocationPanel.height,
          width: MediaQuery.of(context).size.width,
          child: CurrentLocationPanel(
              position: !_locationPermissionsGranted ? null : _position),
        ),
      ),
    ])));
  }
}

class LocationSettingsPanel extends StatelessWidget {
  const LocationSettingsPanel({
    Key? key,
    required this.value,
    required this.disabled,
    required this.onLocationSettingsChanged,
  });

  final LocationSettings value;
  final bool disabled;
  final void Function(LocationSettings) onLocationSettingsChanged;

  static const double height = 60.0;
  static const LocationSettings defaultLocationSettings =
      LocationSettings(distanceFilter: 0);
  static const LocationSettings trackEach3MetersLocationSettings =
      LocationSettings(distanceFilter: 3);
  static const LocationSettings trackEach50MetersLocationSettings =
      LocationSettings(distanceFilter: 50);

  static bool isActive(
          LocationSettings locationSettings, LocationSettings currentValue) =>
      locationSettings.distanceFilter == currentValue.distanceFilter;
  static String getButtonText(
      LocationSettings locationSettings, bool isActive) {
    return '${locationSettings.distanceFilter} meters ${isActive ? '*' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LocationSettingsPanel.defaultLocationSettings,
          LocationSettingsPanel.trackEach3MetersLocationSettings,
          LocationSettingsPanel.trackEach50MetersLocationSettings,
        ]
            .map(
              (settings) => LocationSettingsPanel.isActive(settings, value)
                  ? ElevatedButton(
                      child: Text(LocationSettingsPanel.getButtonText(settings,
                          LocationSettingsPanel.isActive(settings, value))),
                      onPressed: () => onLocationSettingsChanged(settings),
                    )
                  : TextButton(
                      child: Text(LocationSettingsPanel.getButtonText(settings,
                          LocationSettingsPanel.isActive(settings, value))),
                      onPressed: () => onLocationSettingsChanged(settings),
                    ),
            )
            .toList(),
      ),
    );
  }
}

class CurrentLocationPanel extends StatelessWidget {
  const CurrentLocationPanel({
    this.position,
  });

  final Position? position;
  static const double height = 45.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: DefaultTextStyle(
            style: TextStyle(
                fontSize: 10.0, color: Theme.of(context).primaryColor),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: position == null
                      ? const Text('N/A')
                      : Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            const Padding(padding: EdgeInsets.only(left: 10.0)),
                            Text(position.toString()),
                          ],
                        ),
                ))));
  }
}

class ProvidedPositionExampleMap extends StatefulWidget {
  const ProvidedPositionExampleMap({
    Key? key,
    required this.position,
    required this.locationPermissionsGranted,
  }) : super(key: key);

  final Position? position;
  final bool locationPermissionsGranted;

  @override
  _ProvidedPositionExampleMapState createState() =>
      _ProvidedPositionExampleMapState();
}

class _ProvidedPositionExampleMapState
    extends State<ProvidedPositionExampleMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(0, 0),
        zoom: 16,
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
        if (widget.locationPermissionsGranted && widget.position != null)
          LocationMarkerLayerWidget(
            plugin: LocationMarkerPlugin(
              position: widget.position,
              centerOnLocationUpdate:  CenterOnLocationUpdate.always,
            ),
          ),
      ],
    );
  }
}

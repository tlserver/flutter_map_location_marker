import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

// If you want to act with original stream, also see the commented codes.
/*
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
*/

class DefaultStreamExample extends StatefulWidget {
  @override
  State<DefaultStreamExample> createState() => _DefaultStreamExampleState();
}

class _DefaultStreamExampleState extends State<DefaultStreamExample> {
  late final Stream<LocationMarkerPosition?> _positionStream;
  late final Stream<LocationMarkerHeading?> _headingStream;

/*
  late final Stream<Position?> _geolocatorStream;
  late final Stream<CompassEvent?> _compassStream;
*/

  @override
  void initState() {
    super.initState();
    const factory = LocationMarkerDataStreamFactory();
    _positionStream =
        factory.fromGeolocatorPositionStream().asBroadcastStream();
    _headingStream = factory.fromCompassHeadingStream().asBroadcastStream();

    // Get streams with default settings.
/*
    _geolocatorStream = factory.defaultPositionStreamSource().asBroadcastStream();
    _compassStream = factory.defaultHeadingStreamSource().asBroadcastStream();
*/

    // Or get streams with your own settings.
/*
    _geolocatorStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(),
    ).asBroadcastStream();
    _compassStream = FlutterCompass.events!.asBroadcastStream();
*/
  }

  @override
  Widget build(BuildContext context) {
/*
    const factory = LocationMarkerDataStreamFactory();
*/
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Stream Example'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(0, 0),
                initialZoom: 1,
                minZoom: 0,
                maxZoom: 19,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'net.tlserver6y.flutter_map_location_marker.example',
                  maxZoom: 19,
                ),
                CurrentLocationLayer(
                  positionStream: _positionStream,
                  headingStream: _headingStream,

                  // Use helper function in factory to cast the streams.
/*
                  positionStream: factory.fromGeolocatorPositionStream(
                    stream: _geolocatorStream,
                  ),
                  headingStream: factory.fromCompassHeadingStream(
                    stream: _compassStream,
                  ),
*/
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PulseAnimationBox(
                  stream: _positionStream,
                  child: const Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                PulseAnimationBox(
                  stream: _headingStream,
                  child: const Text(
                    'H',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PulseAnimationBox extends StatefulWidget {
  final Stream stream;
  final Widget child;

  const PulseAnimationBox({
    super.key,
    required this.stream,
    required this.child,
  });

  @override
  State<PulseAnimationBox> createState() => _PulseAnimationBoxState();
}

class _PulseAnimationBoxState extends State<PulseAnimationBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _aniController;
  late final Animation<double> _sizeAni;
  late final Animation<double> _opacityAni;
  late final Animation<Color?> _colorAni;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );
    _sizeAni = Tween(
      begin: 20.0,
      end: 60.0,
    ).animate(
      CurvedAnimation(
        parent: _aniController,
        curve: const Interval(
          0,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    _opacityAni = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _aniController,
        curve: const Interval(
          0,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    _colorAni = ColorTween(
      begin: Colors.blue,
      end: Colors.grey.shade300,
    ).animate(
      CurvedAnimation(
        parent: _aniController,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.ease,
        ),
      ),
    );
    _subscript();
  }

  @override
  void didUpdateWidget(PulseAnimationBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _subscription?.cancel();
      _subscript();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _aniController,
      builder: (BuildContext context, child) {
        return SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _colorAni.value ?? Colors.grey.shade300,
                    blurRadius: 2,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.blue.withOpacity(_opacityAni.value),
                    blurRadius: 10,
                    spreadRadius: _sizeAni.value,
                  ),
                ],
              ),
              child: Center(
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _aniController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _subscript() {
    _subscription = widget.stream.listen((event) {
      _aniController.forward(from: 0.0);
    });
  }
}

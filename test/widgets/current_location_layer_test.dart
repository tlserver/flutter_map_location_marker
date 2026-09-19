import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('CurrentLocationLayer', () {
    testWidgets('Should cancel the heading subscription when the layer is '
        'disposed after a position dropout and recovery', (tester) async {
      final positions = StreamController<LocationMarkerPosition?>.broadcast();
      final headings = StreamController<LocationMarkerHeading?>.broadcast();
      addTearDown(positions.close);
      addTearDown(headings.close);

      await tester.pumpWidget(_buildApp(positions.stream, headings.stream));

      // A position fix subscribes to the heading stream and readies the layer.
      positions.add(_position);
      await tester.pump(const Duration(seconds: 1));

      headings.add(LocationMarkerHeading(heading: 1, accuracy: 0.3));
      await tester.pump(const Duration(seconds: 1));

      // A dropout resets the status but leaves the heading subscription live.
      positions.add(null);
      await tester.pump(const Duration(seconds: 1));

      // The recovery subscribes to the heading stream a second time.
      positions.add(_position);
      await tester.pump(const Duration(seconds: 1));

      await tester.pumpWidget(
        _buildApp(positions.stream, headings.stream, withLayer: false),
      );
      await tester.pump(const Duration(seconds: 1));

      // No subscription may outlive the layer, or the sensor never stops.
      expect(headings.hasListener, isFalse);

      // A late sensor error must not reach the disposed state.
      headings.addError(Exception('sensor fault'));
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
    });
  });
}

final _position = LocationMarkerPosition(
  latitude: 52.52,
  longitude: 13.405,
  accuracy: 10,
);

Widget _buildApp(
  Stream<LocationMarkerPosition?> positionStream,
  Stream<LocationMarkerHeading?> headingStream, {
  bool withLayer = true,
}) => MaterialApp(
  home: FlutterMap(
    options: const MapOptions(initialCenter: LatLng(52.52, 13.405)),
    children: [
      if (withLayer)
        CurrentLocationLayer(
          positionStream: positionStream,
          headingStream: headingStream,
        ),
    ],
  ),
);

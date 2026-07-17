import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('LocationMarkerLayer', () {
    testWidgets('Should not draw an accuracy circle when the accuracy is not '
        'finite', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          LocationMarkerPosition(
            latitude: 52.52,
            longitude: 13.405,
            accuracy: double.nan,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(CircleLayer), findsNothing);
    });

    testWidgets('Should draw an accuracy circle when the accuracy is finite', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildApp(
          LocationMarkerPosition(
            latitude: 52.52,
            longitude: 13.405,
            accuracy: 10,
          ),
        ),
      );

      expect(find.byType(CircleLayer), findsOneWidget);
    });
  });
}

Widget _buildApp(LocationMarkerPosition position) => MaterialApp(
  home: FlutterMap(
    options: const MapOptions(initialCenter: LatLng(52.52, 13.405)),
    children: [LocationMarkerLayer(position: position)],
  ),
);

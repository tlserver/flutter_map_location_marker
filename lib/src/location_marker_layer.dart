import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'data.dart';
import 'drawing/heading_sector.dart';
import 'marker_direction.dart';
import 'style.dart';

/// A layer for location marker in [FlutterMap].
class LocationMarkerLayer extends StatelessWidget {
  /// A position with accuracy.
  final LocationMarkerPosition position;

  /// A angle with accuracy.
  final LocationMarkerHeading? heading;

  /// The style to use for this location marker.
  final LocationMarkerStyle style;

  /// Create a LocationMarkerLayer.
  const LocationMarkerLayer({
    super.key,
    required this.position,
    this.heading,
    this.style = const LocationMarkerStyle(),
  });

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context)!;
    return Stack(
      children: [
        if (style.showAccuracyCircle)
          CircleLayer(
            circles: [
              CircleMarker(
                point: position.latLng,
                radius: position.accuracy,
                useRadiusInMeter: true,
                color: style.accuracyCircleColor,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (style.showHeadingSector && heading != null)
              Marker(
                point: position.latLng,
                width: style.headingSectorRadius * 2,
                height: style.headingSectorRadius * 2,
                builder: (BuildContext context) {
                  return IgnorePointer(
                    child: CustomPaint(
                      size: Size.fromRadius(
                        style.headingSectorRadius,
                      ),
                      painter: HeadingSector(
                        style.headingSectorColor,
                        heading!.heading,
                        heading!.accuracy,
                      ),
                    ),
                  );
                },
              ),
            Marker(
              point: position.latLng,
              width: style.markerSize.width,
              height: style.markerSize.height,
              builder: (BuildContext context) {
                switch (style.markerDirection) {
                  case MarkerDirection.north:
                    return style.marker;
                  case MarkerDirection.top:
                    return Transform.rotate(
                      angle: -mapState.rotationRad,
                      child: style.marker,
                    );
                  case MarkerDirection.heading:
                    if (heading != null) {
                      return Transform.rotate(
                        angle: heading!.heading,
                        child: style.marker,
                      );
                    } else {
                      return Transform.rotate(
                        angle: -mapState.rotationRad,
                        child: style.marker,
                      );
                    }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

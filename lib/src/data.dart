import 'package:latlong2/latlong.dart';

class LocationMarkerPosition {
  /// The latitude, in degrees
  final double latitude;

  /// The longitude, in degrees
  final double longitude;

  /// The estimated horizontal accuracy of this location, radial, in meters
  final double accuracy;

  LocationMarkerPosition({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  get latLng => LatLng(latitude, longitude);
}

class LocationMarkerHeading {
  /// The heading, in radius
  final double heading;

  /// The estimated accuracy of this heading, in radius
  final double accuracy;

  LocationMarkerHeading({
    required this.heading,
    required this.accuracy,
  });
}

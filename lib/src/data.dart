import 'package:latlong2/latlong.dart';

/// A position with accuracy for marker rendering.
class LocationMarkerPosition {
  /// The latitude, in degrees. The range should be -90 (inclusive) to +90
  /// (inclusive).
  final double latitude;

  /// The longitude, in degrees. The range should be -180 (exclusive) to +180
  /// (inclusive).
  final double longitude;

  /// The estimated horizontal accuracy of this location, radial, in meters. The
  /// smaller value, the better accuracy.
  final double accuracy;

  /// Create a LocationMarkerPosition.
  LocationMarkerPosition({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  /// Convert to LatLng object
  LatLng get latLng => LatLng(latitude, longitude);
}

/// A angle with accuracy for marker rendering.
class LocationMarkerHeading {
  /// The heading, in radius, which 0 radians being the north and positive
  /// angles going clockwise.
  final double heading;

  /// The estimated accuracy of this heading, in radius.The smaller value, the
  /// better accuracy.
  final double accuracy;

  /// Create a LocationMarkerHeading.
  LocationMarkerHeading({
    required this.heading,
    required this.accuracy,
  });
}

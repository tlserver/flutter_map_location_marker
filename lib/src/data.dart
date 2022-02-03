import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Represents the position to assign the
/// Marker
class LocationMarkerPosition {
  /// Represents the position to assign the
  /// Marker
  LocationMarkerPosition({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  /// Parses the [Position] given by the [Geolocator]
  factory LocationMarkerPosition.from(Position position) =>
      LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );

  /// The latitude, in degrees
  final double latitude;

  /// The longitude, in degrees
  final double longitude;

  /// The estimated horizontal accuracy of this location, radial, in meters
  final double accuracy;

  /// Returns the [LatLng] version of the position
  LatLng get latLng => LatLng(latitude, longitude);

  @override
  String toString() => "LocationMarkerPosition(lat: $latitude, lng: $longitude, accuracy: $accuracy)";
}

/// The Heading of the device
class LocationMarkerHeading {
  /// The Heading of the device
  LocationMarkerHeading({required this.heading, required this.accuracy});

  /// The heading, in radius
  final double heading;

  /// The estimated accuracy of this heading, in radius
  final double accuracy;
}

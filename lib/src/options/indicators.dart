import 'package:flutter/material.dart';

import '../../flutter_map_location_marker.dart';

/// An object to store indicators widget for special status of
/// [CurrentLocationLayer].
@immutable
class LocationMarkerIndicators {
  /// A widget shown when in permission requesting status.
  final Widget? permissionRequesting;

  /// A widget shown when in permission denied status.
  final Widget? permissionDenied;

  /// A widget shown when in service disabled status.
  final Widget? serviceDisabled;

  /// Create a LocationMarkerIndicators.
  const LocationMarkerIndicators({
    this.permissionRequesting,
    this.permissionDenied,
    this.serviceDisabled,
  });
}

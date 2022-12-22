/// An exception thrown when trying to access the device's location information
/// while the location service on the device is disabled.
class ServiceDisabledException implements Exception {
  /// Create a ServiceDisabledException.
  const ServiceDisabledException();
}

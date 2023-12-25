/// An exception thrown when requesting location permissions while an earlier
/// request has not yet been completed.
class PermissionRequestingException implements Exception {
  /// Create a PermissionRequestingException.
  const PermissionRequestingException();
}

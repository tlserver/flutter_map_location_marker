import 'package:flutter/foundation.dart';

/// An exception thrown when an operation is not supported on the current
/// platform.
class UnsupportedException implements Exception {
  final String library;

  /// Create an UnsupportedException.
  const UnsupportedException(this.library);

  @override
  String toString() {
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
    return '$library does not support the $platform platform.';
  }
}

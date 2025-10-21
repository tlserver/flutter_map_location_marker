import 'package:flutter/foundation.dart';

/// An exception thrown when an operation is not supported on the current
/// platform.
class UnsupportedException implements Exception {
  /// Create an UnsupportedException.
  const UnsupportedException();

  @override
  String toString() {
    final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
    return 'FlutterRotationSensor does not support the $platform platform.';
  }
}

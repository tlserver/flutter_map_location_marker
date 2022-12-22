/// An exception thrown when the required platform specific setup steps have not
/// been correctly done, such as permission definitions could not be found in
/// the AndroidManifest.xml file on Android or in the Info.plist file on iOS.
class IncorrectSetupException implements Exception {
  /// Create an IncorrectSetupException.
  const IncorrectSetupException();
}

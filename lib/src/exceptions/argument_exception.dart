/// An exception thrown when an argument is invalid.
class ArgumentException implements Exception {
  /// The invalid value that caused the exception.
  final dynamic invalidValue;
  /// The name of the argument that caused the exception.
  final String name;
  /// A message describing the exception.
  final String message;

  /// Constructs an ArgumentException.
  ArgumentException(this.invalidValue, this.name, this.message);

  @override
  String toString() {
    var name = this.name;
    var message = this.message;
    var errorValue = Error.safeToString(invalidValue);
    return 'Invalid data ($name = $errorValue) : $message';
  }
}

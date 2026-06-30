class ArgumentException implements Exception {
  final dynamic invalidValue;
  final String name;
  final String message;

  ArgumentException(this.invalidValue, this.name, this.message);

  @override
  String toString() {
    var name = this.name;
    var message = this.message;
    var errorValue = Error.safeToString(invalidValue);
    return 'Invalid data ($name = $errorValue) : $message';
  }
}

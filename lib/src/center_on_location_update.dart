/// Should the map to be centered to new locations.
enum CenterOnLocationUpdate {
  /// Never center the map to new locations.
  never,

  /// Center the map to the new location only the first times. Same as never if
  /// changing to this value after the first location update.
  once,

  /// Always center the map to new locations.
  always,
}

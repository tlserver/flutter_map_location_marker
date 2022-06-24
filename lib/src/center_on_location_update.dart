/// Should the map to be centered on the new location when location is updated.
enum CenterOnLocationUpdate {
  /// Never center on new location.
  never,

  /// Center on the new location only the first times. Same as never if
  /// changing to this value after the first location update.
  once,

  /// Always center on the new location.
  always,
}

/// Should the map follow the new location when location is updated.
enum FollowOnLocationUpdate {
  /// Never follow new location.
  never,

  /// Follow the new location only the first times. Same as never if changing to
  /// this value after the first location update.
  once,

  /// Always follow the new location.
  always,
}

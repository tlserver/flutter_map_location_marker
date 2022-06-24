/// Should the map to be turned when heading is updated.
enum TurnOnHeadingUpdate {
  /// Never turn heading up.
  never,

  /// Turn new heading up only the first times. Same as never if changing to
  /// this value after the first location update.
  once,

  /// Always turn new heading up.
  always,
}

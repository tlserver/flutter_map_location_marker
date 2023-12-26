/// Determines whether an 'align position event' or 'align direction event'
/// should be emitted upon location or heading updates.
enum AlignOnUpdate {
  /// Never emit an align event.
  never,

  /// Emit an align event only on the first update. This is equivalent to
  /// 'never' if set after the first update has occurred.
  once,

  /// Always emit align events.
  always,
}

@Deprecated("Use 'AlignOnUpdate' instead")
typedef FollowOnLocationUpdate = AlignOnUpdate;
@Deprecated("Use 'AlignOnUpdate' instead")
typedef TurnOnHeadingUpdate = AlignOnUpdate;

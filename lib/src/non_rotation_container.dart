import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';

/// A container that revert the rotation in Flutter Map. This container can be
/// used in a rotation child only. By using this container, the widget inside
/// is shown as in non rotation child.
class NonRotationContainer extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Create a NonRotationContainer.
  const NonRotationContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.maybeOf(context)!;

    final size = Size(camera.nonRotatedSize.x, camera.nonRotatedSize.y);
    return Transform.rotate(
      angle: -camera.rotationRad,
      child: OverflowBox(
        maxWidth: size.width,
        maxHeight: size.height,
        child: SizedBox.fromSize(
          size: size,
          child: child,
        ),
      ),
    );
  }
}

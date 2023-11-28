import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The default [Widget] that shows the device's position. By default, it is a
/// blue circle with a white border. The color can be changed and a child can be
/// displayed inside the circle.
class DefaultLocationMarker extends StatelessWidget {
  /// The color of the marker. Default to ARGB(0xFF2196F3).
  final Color color;

  /// Typically the marker's icon. Default to null.
  final Widget? child;

  /// Create a DefaultLocationMarker.
  const DefaultLocationMarker({
    super.key,
    this.color = const Color(0xFF2196F3),
    this.child,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
  }
}

import 'package:flutter/material.dart';

/// The default [Widget] that shows the device's position. By default, it is a
/// blue circle with a white border. The color can be changed and a child can be
/// displayed inside the circle.
class DefaultLocationMarker extends StatelessWidget {
  /// The color of the marker.
  final Color color;

  /// Typically the marker's icon.
  final Widget? child;

  /// Create a DefaultLocationMarker.
  const DefaultLocationMarker({
    Key? key,
    this.color = const Color.fromARGB(0xFF, 0x21, 0x96, 0xF3),
    this.child,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
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
  }
}

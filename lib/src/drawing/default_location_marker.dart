import 'package:flutter/material.dart';

/// The default [Widget] that shows the device's position
class DefaultLocationMarker extends StatelessWidget {
  /// The default [Widget] that shows the device's position
  const DefaultLocationMarker({
    Key? key,
    this.color = const Color.fromARGB(0xFF, 0x21, 0x96, 0xF3),
    this.child,
  }) : super(key: key);

  /// The color of the marker
  final Color color;

  /// Optional child to be put inside the marker
  final Widget? child;

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

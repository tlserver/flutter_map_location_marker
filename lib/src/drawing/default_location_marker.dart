import 'package:flutter/material.dart';

class DefaultLocationMarker extends StatelessWidget {
  final Color color;
  final Widget? child;

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
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
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

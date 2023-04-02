import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tappable extends StatelessWidget {
  const Tappable({
    Key? key,
    required this.child,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
    this.hitTestBehavior = HitTestBehavior.opaque,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Widget child;
  final SystemMouseCursor cursor;
  final HitTestBehavior hitTestBehavior;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: cursor,
      hitTestBehavior: hitTestBehavior,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myguide/ui/spacers.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inputDecorTheme = Theme.of(context).inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppInsets.xs,
          child: Text(label, style: inputDecorTheme.labelStyle),
        ),
        child
      ],
    );
  }
}

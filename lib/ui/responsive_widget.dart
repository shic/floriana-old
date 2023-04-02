import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/routing/router.dart';

extension ResponsiveValue on TargetPlatform {
  T when<T>({
    required BuildContext context,
    required T mobile,
    required T desktop,
  }) {
    final currentPlatform = Theme.of(context).platform;
    switch (currentPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return mobile;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        final mediaQuery = MediaQuery.of(context).size;
        if (mediaQuery.width < 1050) return mobile;
        return desktop;
    }
  }
}

class CreateNewButton extends StatelessWidget {
  const CreateNewButton({Key? key, required this.path,}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.go(path),
      icon: const Icon(Icons.add),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/controller.dart';
import 'package:myguide/ui/dialog.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final auth = ref.watch(authProvider);
      if (auth.isAnonymous) return const SizedBox();
      final theme = Theme.of(context);
      return IconButton(
        onPressed: () {
          context.guardThrowable(
            operation: () => ref.read(authProvider.notifier).signOut(),
          );
        },
        icon: Icon(Icons.logout, color: theme.colorScheme.error),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/controller.dart';
import 'package:myguide/core/services/auth_service.dart';

class RoleConsumer extends ConsumerWidget {
  const RoleConsumer({
    super.key,
    this.manager,
    this.user,
    this.anonymous,
  });

  final Widget Function()? manager;
  final Widget Function()? user;
  final Widget Function()? anonymous;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (auth.hasRole(AuthRole.manager)) {
      return manager?.call() ?? const SizedBox();
    }

    if (auth.hasRole(AuthRole.user)) {
      return user?.call() ?? const SizedBox();
    }

    return anonymous?.call() ?? const SizedBox();
  }
}

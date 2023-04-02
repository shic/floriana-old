import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/services/auth_service.dart';
import 'package:myguide/pages/auth_page.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_user.dart';
import 'package:myguide/ui/empty_state.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/spacers.dart';

class AuthRequired extends ConsumerStatefulWidget {

  const AuthRequired.manager({
    super.key,
    required this.child,
  }) : _role = AuthRole.manager;

  const AuthRequired.user({
    super.key,
    required this.child,
  }) : _role = AuthRole.user;

  final Widget child;
  final AuthRole _role;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthRequiredState();
}

class _AuthRequiredState extends ConsumerState<AuthRequired>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    if (!auth.isAnonymous) {
      switch (widget._role) {
        case AuthRole.anonymous:
          return widget.child;
        case AuthRole.user:
          if (auth.hasRole(AuthRole.user)) return widget.child;
          break;
        case AuthRole.manager:
          if (auth.hasRole(AuthRole.manager)) return widget.child;
          break;
      }
      return const _UnauthorizedWidget();
    }
    return const AuthPage();
  }
}

class _UnauthorizedWidget extends StatelessWidget {
  const _UnauthorizedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).padding +
          defaultTargetPlatform.when(
            context: context,
            mobile: AppInsets.page,
            desktop: AppInsets.hpage +
                EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * .2,
                ),
          ),
      child: EmptyState.error(
        message: 'You have not the authorization to see this content',
        action: ElevatedButton(
          onPressed: () => context.go(ExhibitionListRoute.rawPath),
          child: const Text('Home page'),
        ),
      ),
    );
  }
}


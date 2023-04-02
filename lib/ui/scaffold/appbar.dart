import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_user.dart';
import 'package:myguide/ui/assets.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/manager.dart';
import 'package:myguide/ui/scaffold/user.dart';
import 'package:myguide/ui/tappable.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    Key? key,
    required this.title,
    this.actions = const [],
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String title;
  final List<Widget> actions;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      automaticallyImplyLeading: defaultTargetPlatform.when(
        context: context,
        mobile: true,
        desktop: false,
      ),
      title: _AppBarTitle(title: title),
      actions: [
        ...actions,
        const _MenuButton(),
        const _TrailingSpace(),
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform.when(
      context: context,
      mobile: Tappable(
        onTap: () => context.go(ExhibitionListRoute.rawPath),
        child: Logo.build(height: 40),
      ),
      desktop: const Offstage(),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform.when(
      context: context,
      mobile: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          UserScaffold.openDrawer(context);
          ManagerScaffold.openDrawer(context);
        },
      ),
      desktop: const SizedBox(),
    );
  }
}

class _TrailingSpace extends StatelessWidget {
  const _TrailingSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform.when(
      context: context,
      mobile: const SizedBox(),
      desktop: SizedBox(
        width: MediaQuery.of(context).size.width * .22,
      ),
    );
  }
}

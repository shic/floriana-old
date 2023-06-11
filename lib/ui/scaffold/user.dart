import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/routes_user.dart' as user;
import 'package:myguide/routing/routes_manager.dart' as manager;
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/menu.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum UserScaffoldTab {
  favorites(user.FavoriteListRoute.rawPath),
  home(user.HomeRoute.rawPath),
  exhibitions(user.ExhibitionListRoute.rawPath),
  monuments(user.MonumentListRoute.rawPath),
  profile(user.ProfileRoute.rawPath);

  const UserScaffoldTab(this.path);

  static UserScaffoldTab? fromRouter(GoRouter router) {
    final matches = router.routerDelegate.currentConfiguration.matches;
    final sublocs = matches.map((e) => e.subloc);

    for (final tab in UserScaffoldTab.values) {
      if (sublocs.contains(tab.path)) return tab;
    }
    return null;
  }

  final String path;

  String title(AppLocalizations copy) {
    switch (this) {
      case UserScaffoldTab.home:
        return copy.home;
        case UserScaffoldTab.exhibitions:
        return copy.exhibitions;
      case UserScaffoldTab.monuments:
        return copy.monuments;
      case UserScaffoldTab.favorites:
        return copy.home;
      case UserScaffoldTab.profile:
        return copy.profile;
    }
  }
}

class UserScaffold extends StatefulWidget {
  const UserScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static _UserScaffoldState? _state(BuildContext context) {
    return context.findAncestorStateOfType();
  }

  static void closeDrawer(BuildContext context) {
    _state(context)?._scaffoldKey.currentState?.closeEndDrawer();
  }

  static void openDrawer(BuildContext context) {
    _state(context)?._scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  State<UserScaffold> createState() => _UserScaffoldState();
}

class _UserScaffoldState extends State<UserScaffold> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = UserScaffoldTab.fromRouter(GoRouter.of(context));
    final copy = AppLocalizations.of(context)!;
    final items = [
      UserScaffoldTab.values.map((tab) {
        return AppScaffoldMenuItem(
          title: tab.title(copy),
          selected: tab == currentTab,
          onTap: () {
            _scaffoldKey.currentState!.closeEndDrawer();
            context.go(tab.path);
          },
        );
      }),
    ];
    final roleChangeItem = RoleConsumer(
      manager: () {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () => context.go(manager.ExhibitionListRoute.rawPath),
            child: Text(copy.navigateAsManager, textAlign: TextAlign.center,),
          ),
        );
      },
    );
    final menu = AppScaffoldMenu(
      items:  UserScaffoldTab.values.map((tab) {
        return AppScaffoldMenuItem(
          title: tab.title(copy),
          selected: tab == currentTab,
          onTap: () {
            _scaffoldKey.currentState!.closeEndDrawer();
            context.go(tab.path);
          },
        );
      }),
      roleChangeItem: roleChangeItem,
    );
    return defaultTargetPlatform.when(
      context: context,
      mobile: _buildMobile(context, menu: menu),
      desktop: _buildDesktop(context, menu: menu),
    );
  }

  Widget _buildMobile(BuildContext context, {required AppScaffoldMenu menu}) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: menu,
      body: widget.child,
    );
  }

  Widget _buildDesktop(BuildContext context, {required AppScaffoldMenu menu}) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          Padding(padding: const EdgeInsets.only(top: 10), child: menu),
          Expanded(flex: 10, child: widget.child),
        ],
      ),
    );
  }
}

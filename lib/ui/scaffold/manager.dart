import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/routes_user.dart' as user;
import 'package:myguide/routing/routes_manager.dart' as manager;
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/menu.dart';

enum ManagerScaffoldTab {
  exhibitions(manager.ExhibitionListRoute.rawPath),
  artworks(manager.ArtworkListRoute.rawPath),
  authors(manager.AuthorListRoute.rawPath),
  profile(manager.ProfileRoute.rawPath);

  const ManagerScaffoldTab(this.path);

  static ManagerScaffoldTab? fromRouter(GoRouter router) {
    final matches = router.routerDelegate.currentConfiguration.matches;
    final sublocs = matches.map((e) => e.subloc);

    for (final tab in ManagerScaffoldTab.values) {
      if (sublocs.contains(tab.path)) return tab;
    }
    return null;
  }

  final String path;

  String title(AppLocalizations copy) {
    switch (this) {
      case ManagerScaffoldTab.exhibitions:
        return copy.exhibitions;
      case ManagerScaffoldTab.artworks:
        return copy.artworks;
      case ManagerScaffoldTab.authors:
        return copy.authors;
      case ManagerScaffoldTab.profile:
        return copy.profile;
    }
  }
}

class ManagerScaffold extends StatefulWidget {
  const ManagerScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static _ManagerScaffoldState? _state(BuildContext context) {
    return context.findAncestorStateOfType();
  }

  static void closeDrawer(BuildContext context) {
    _state(context)?._scaffoldKey.currentState?.closeEndDrawer();
  }

  static void openDrawer(BuildContext context) {
    _state(context)?._scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  State<ManagerScaffold> createState() => _ManagerScaffoldState();
}

class _ManagerScaffoldState extends State<ManagerScaffold> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ManagerScaffoldTab.fromRouter(GoRouter.of(context));
    final copy = AppLocalizations.of(context)!;
    final items = ManagerScaffoldTab.values.map((tab) {
      return AppScaffoldMenuItem(
        title: tab.title(copy),
        selected: tab == currentTab,
        onTap: () {
          _scaffoldKey.currentState!.closeEndDrawer();
          context.go(tab.path);
        },
      );
    });
    final roleChangeItem = RoleConsumer(
      manager: () {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () => context.go(user.ExhibitionListRoute.rawPath),
            child: Text(copy.navigateAsUser, textAlign: TextAlign.center,),
          ),
        );
      },
    );
    final menu = AppScaffoldMenu(
      items: items,
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

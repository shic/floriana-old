import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/pages/auth_page.dart';

import 'package:myguide/routing/routes_manager.dart' as manager;
import 'package:myguide/routing/routes_user.dart' as user;
import 'package:myguide/ui/scaffold/manager.dart';
import 'package:myguide/ui/scaffold/user.dart';

export 'package:go_router/go_router.dart';

class AuthRoute extends AppRoute {
  static const rawPath = '/auth';

  static String route() => rawPath;

  AuthRoute()
      : super(
          path: rawPath,
          builder: (context, _) {
            return Scaffold(
              body: AuthPage(onComplete: () => GoRouter.of(context).pop()),
            );
          },
        );
}

final userShellNavigatorKey = GlobalKey<NavigatorState>();
final managerShellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter extends GoRouter {
  AppRouter()
      : super(
          debugLogDiagnostics: true,
          routes: [
            GoRoute(
              path: '/',
              redirect: (_, __) => user.ExhibitionListRoute.route(),
            ),
            AuthRoute(),
            ShellRoute(
              navigatorKey: userShellNavigatorKey,
              builder: (_, routerState, child) {
                return UserScaffold(key: routerState.pageKey, child: child);
              },
              routes: <RouteBase>[
                user.ExhibitionListRoute(),
                user.MonumentListRoute(),
                user.ArtworkDetailRoute(),
                user.FavoriteListRoute(),
                user.ProfileRoute(),
              ],
            ),

            GoRoute(
              path: '/manager',
              redirect: (_, __) => '/manager/exhibitions',
            ),
            ShellRoute(
              navigatorKey: managerShellNavigatorKey,
              builder: (_, routerState, child) {
                return ManagerScaffold(key: routerState.pageKey, child: child);
              },
              routes: <RouteBase>[
                manager.ExhibitionListRoute(),
                manager.ArtworkListRoute(),
                manager.AuthorListRoute(),
                manager.ProfileRoute(),
              ],
            ),
            // Unauthorized
            GoRoute(
              path: '/unauthorized',
              pageBuilder: (_, __) {
                return AppTransitionBuilder.fade(
                  child: const Scaffold(
                    backgroundColor: Colors.red,
                    body: Center(child: Text('Unauthorized')),
                  ),
                );
              },
            ),
          ],
        );
}

class AppRoute extends GoRoute {
  AppRoute({
    required super.path,
    required GoRouterWidgetBuilder builder,
    super.routes,
    super.redirect,
    super.parentNavigatorKey,
  }) : super(pageBuilder: (context, state) {
          return AppTransitionBuilder.fade(child: builder(context, state));
        });
}

class AppTransitionBuilder {
  static const _duration = Duration(milliseconds: 250);

  static CustomTransitionPage fade({
    LocalKey? key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: _duration,
      transitionsBuilder: (context, animation, _, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage modal({
    LocalKey? key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: _duration,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween<Offset>(begin: const Offset(0, .6), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.fastOutSlowIn)),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

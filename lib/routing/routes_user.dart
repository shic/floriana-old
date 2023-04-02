import 'package:myguide/pages/user/pages.dart';
import 'package:myguide/routing/router.dart';

class ExhibitionListRoute extends AppRoute {
  static const rawPath = '/exhibitions';

  static String route() => rawPath;

  ExhibitionListRoute()
      : super(
          path: rawPath,
          builder: (_, __) => const ExhibitionListPage(),
          routes: [ExhibitionDetailRoute()],
        );
}

class ExhibitionDetailRoute extends AppRoute {
  static const rawPath = ':id';

  static String route({required String id}) {
    return '${ExhibitionListRoute.rawPath}/$id';
  }

  ExhibitionDetailRoute()
      : super(
          path: rawPath,
          builder: (_, state) {
            final id = state.params['id']!;
            return ExhibitionDetailPage(id: id);
          },
        );
}

class ArtworkDetailRoute extends AppRoute {
  static const rawPath = '/artworks/:id';

  static String route({required String id}) {
    return '/artworks/$id';
  }

  ArtworkDetailRoute()
      : super(
          path: rawPath,
          builder: (_, state) {
            final id = state.params['id']!;
            return ArtworkDetailPage(id: id);
          },
        );
}

class FavoriteListRoute extends AppRoute {
  static const rawPath = '/favorites';

  static String route() => rawPath;

  FavoriteListRoute()
      : super(
          path: rawPath,
          builder: (_, state) => const FavoriteListPage(),
        );
}

class MonumentListRoute extends AppRoute {
  static const rawPath = '/monuments';

  static String route() => rawPath;

  MonumentListRoute()
      : super(
          path: rawPath,
          builder: (_, __) => const MonumentListPage(),
          routes: [MonumentDetailRoute()],
        );
}

class MonumentDetailRoute extends AppRoute {
  static const rawPath = ':id';

  static String route({required String id}) {
    return '${MonumentListRoute.rawPath}/$id';
  }

  MonumentDetailRoute()
      : super(
          path: rawPath,
          builder: (_, state) {
            final id = state.params['id']!;
            return MonumentDetailPage(id: id);
          },
        );
}

class ProfileRoute extends AppRoute {
  static const rawPath = '/profile';

  static String route() => rawPath;

  ProfileRoute()
      : super(
    path: rawPath,
    builder: (_, __) => const ProfilePage(),
  );
}

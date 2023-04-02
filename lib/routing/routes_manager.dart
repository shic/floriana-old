import 'package:myguide/pages/manager/pages.dart';
import 'package:myguide/routing/router.dart';

class ExhibitionListRoute extends AppRoute {
  static const rawPath = '/manager/exhibitions';

  static String route() => rawPath;

  ExhibitionListRoute()
      : super(
          path: rawPath,
          builder: (_, __) => const ExhibitionListPage(),
          routes: [ExhibitionEditRoute()],
        );
}

class ExhibitionEditRoute extends AppRoute {
  static const rawPath = ':id';

  static String route({String? id}) {
    return '${ExhibitionListRoute.rawPath}/${id ?? 'create'}';
  }

  ExhibitionEditRoute()
      : super(
          path: rawPath,
          builder: (_, state) {
            final id = state.params['id'];
            return ExhibitionEditPage(id: id);
          },
        );
}

class ArtworkListRoute extends AppRoute {
  static const rawPath = '/manager/artworks';

  static String route() => rawPath;

  ArtworkListRoute()
      : super(
          path: rawPath,
          builder: (_, __) => const ArtworkListPage(),
          routes: [ArtworkEditRoute()],
        );
}

class ArtworkEditRoute extends AppRoute {
  static const rawPath = ':id';

  static String route({String? id}) {
    return '${ArtworkListRoute.rawPath}/${id ?? 'create'}';
  }

  ArtworkEditRoute()
      : super(
          path: rawPath,
          builder: (_, state) {
            final id = state.params['id'];
            return ArtworkEditPage(id: id);
          },
        );
}

class AuthorListRoute extends AppRoute {
  static const rawPath = '/manager/authors';

  static String route() => rawPath;

  AuthorListRoute()
      : super(
          path: rawPath,
          builder: (_, __) => const AuthorListPage(),
          routes: [AuthorEditRoute()],
        );
}

class AuthorEditRoute extends AppRoute {
  static const rawPath = ':id';

  static String route({String? id}) {
    return '${AuthorListRoute.rawPath}/${id ?? 'create'}';
  }

  AuthorEditRoute()
      : super(
          path: rawPath,
          builder: (_, state) {
            final id = state.params['id'];
            return AuthorEditPage(id: id == 'create' ? null : id);
          },
        );
}

class ProfileRoute extends AppRoute {
  static const rawPath = '/manager/profile';

  static String route() => rawPath;

  ProfileRoute()
      : super(
          path: rawPath,
          builder: (_, __) => const ProfilePage(),
        );
}

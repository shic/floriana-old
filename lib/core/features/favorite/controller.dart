import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/user_management/all.dart';
import 'package:myguide/core/services/db_service.dart';

typedef FavoriteState = AsyncValue<Iterable<String>>;

final favoritesProvider =
    StateNotifierProvider.autoDispose<FavoriteController, FavoriteState>((ref) {
  final uid = ref.watch(uidProvider);
  final favorites = ref.watch(
    userProvider.select((user) => user.value?.favorites),
  );
  return FavoriteController(
    uid: uid,
    favorites: favorites ?? [],
    dbService: DBService(),
  );
});

class FavoriteController extends StateNotifier<FavoriteState> {
  StreamSubscription? subscription;
  final String uid;
  final DBService dbService;

  FavoriteController({
    required this.uid,
    required this.dbService,
    required Iterable<String> favorites,
  }) : super(FavoriteState.data(favorites));

  Future<void> addFavorite(String id) async {
    final path = id.startsWith('a-') ? 'artworks/$id' : 'exhibitions/$id';
    await dbService.batch(
      operations: [
        UpdateOperation(
          path: 'users/$uid',
          data: {
            'favorites': FieldValue.arrayUnion([id])
          },
        ),
        UpdateOperation(path: path, data: {'likes': FieldValue.increment(1)}),
      ],
    );
  }

  Future<void> removeFavorite(String id) async {
    final path = id.startsWith('a-') ? 'artworks/$id' : 'exhibitions/$id';
    await dbService.batch(operations: [
      UpdateOperation(path: 'users/$uid', data: {
        'favorites': FieldValue.arrayRemove([id])
      }),
      UpdateOperation(path: path, data: {'likes': FieldValue.increment(-1)}),
    ]);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/controller.dart';
import 'package:myguide/core/features/user_management/domain.dart';
import 'package:myguide/core/services/db_service.dart';

typedef UserState = AsyncValue<User?>;

final userProvider = StateNotifierProvider<UserController, UserState>((ref) {
  final uid = ref.watch(uidProvider);
  return UserController(
    uid: uid,
    dbService: DBService(),
  );
});

class UserController extends StateNotifier<UserState> {
  UserController({
    required this.uid,
    required this.dbService,
  }) : super(const UserState.loading()) {
    initialize();
  }

  final String uid;
  final DBService dbService;

  void initialize() async {
    dbService
        .doc$(
      path: 'users/$uid',
      converter: (id, map) => User.fromMap({'id': id, ...?map}),
    )
        .listen((event) {
      state = UserState.data(event);
    });
  }

  Future<User> getUserById(String id) {
    return dbService.doc(
      path: 'users/$id',
      converter: (id, map) => User.fromMap({'id': id, ...?map}),
    );
  }

  Future<void> updateUser({
    String? displayName,
    String? avatar,
    String? website,
  }) async {
    await dbService.set(path: 'users/$uid', data: {
      'display_name': displayName,
      'avatar': avatar,
      'website': website,
    });
  }
}

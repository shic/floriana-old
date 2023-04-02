import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/author_management/all.dart';
import 'package:myguide/core/services/db_service.dart';
import 'package:myguide/core/utils/async.dart';

typedef AuthorManagementState = AsyncValue<Iterable<Author>>;

final authorManagementProvider = StateNotifierProvider.autoDispose<
    AuthorManagementController, AuthorManagementState>((ref) {
  final uid = ref.watch(uidProvider);
  return AuthorManagementController(
    uid: uid,
    collectionPath: 'authors',
    dbService: DBService(),
  );
});

class AuthorManagementController extends StateNotifier<AuthorManagementState>
    with StateNotifierSubscriptionMixin {
  AuthorManagementController({
    required this.uid,
    required this.collectionPath,
    required this.dbService,
  }) : super(const AuthorManagementState.loading()) {
    initialize();
  }

  final String uid;
  final String collectionPath;
  final DBService dbService;

  void initialize() async {
    subscriptions = dbService.collection$(
      path: collectionPath,
      converter: (id, map) => Author.fromMap({'id': id, ...?map}),
      where: [Where('manager_id', '==', uid)],
    ).listen((event) {
      if (!mounted) return;
      state = AuthorManagementState.data(event);
    });
  }

  /// CRUD Operations
  Future<void> createNewAuthor({
    required String name,
    String? url,
  }) async {
    await dbService.create(
      prefix: 'c',
      collectionPath: collectionPath,
      data: Author.creationModel(managerId: uid, name: name, url: url),
    );
  }

  Future<void> saveAuthor(Author author) async {
    await dbService.set(
      path: '$collectionPath/${author.id}',
      data: author.toMap(),
    );
  }

  Future<Author> getAuthor(String id) async {
    return await dbService.doc(
      path: '$collectionPath/$id',
      converter: (id, map) => Author.fromMap({'id': id, ...?map}),
    );
  }

  Future<void> deleteAuthor(Author author) async {
    await dbService.delete(path: '$collectionPath/${author.id}');
  }
}

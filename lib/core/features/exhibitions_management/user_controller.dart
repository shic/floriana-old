import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/exhibitions_management/domain.dart';
import 'package:myguide/core/services/db_service.dart';
import 'package:myguide/core/utils/async.dart';

typedef ExhibitionState = AsyncValue<Iterable<Exhibition>>;

final userExhibitionsProvider = StateNotifierProvider.autoDispose<
    UserExhibitionsController, ExhibitionState>((ref) {
  final uid = ref.watch(uidProvider);
  return UserExhibitionsController(
    uid: uid,
    collectionPath: 'exhibitions',
    dbService: DBService(),
  );
});

class UserExhibitionsController extends StateNotifier<ExhibitionState> {
  UserExhibitionsController({
    required this.uid,
    required this.collectionPath,
    required this.dbService,
  }) : super(const ExhibitionState.loading()) {
    initialize();
  }

  final String uid;
  final String collectionPath;
  final DBService dbService;

  void initialize() async {
    dbService.collection$(
      path: collectionPath,
      converter: (id, map) => Exhibition.fromMap({'id': id, ...?map}),
      where: [
        Where.greaterThan(
          field: 'date_range.end',
          target: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    ).listen((event) {
      final data = event.where((e) => e.status == ExhibitionStatus.visible);
      if (!mounted) return;
      state = ExhibitionState.data(data);
    });
  }

  Future<Exhibition?> getExhibition({String? id}) async {
    if (id == null) return null;
    final exhibitions = await first;
    return exhibitions.firstWhereOrNull((exhibition) {
      return exhibition.id == id;
    });
  }
}

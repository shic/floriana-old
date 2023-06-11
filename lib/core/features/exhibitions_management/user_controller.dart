import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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


      Map<int, List<String>> dataByProvider = {
        1: ['1', '2', '3']
      };
      Exhibition exhibition = Exhibition(
        id: "1",
        managerId: "1",
        name: "ex name",
        description: "ex description",
        status: ExhibitionStatus.visible,
        address: "address",
        dateRange:
        DateTimeRange(start: DateTime(2010), end: DateTime(2011)),
        unavailableDates: const [],
        workingHours: dataByProvider,
        artworkIds: const ["11"],
        likes: 100,
        imageURL:"/assets/exhibition/1/0.jpeg",
      );
      final List<Exhibition> exhibitionList = [];

      exhibitionList.add(exhibition);
      exhibitionList.add(exhibition);
      exhibitionList.add(exhibition);


      state = ExhibitionState.data(exhibitionList.toList());
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

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/exhibitions_management/domain.dart';
import 'package:myguide/core/services/db_service.dart';
import 'package:myguide/core/utils/async.dart';

typedef ExhibitionState = AsyncValue<Iterable<Exhibition>>;

final exhibitionManagementProvider = StateNotifierProvider.autoDispose<
    ExhibitionManagementController, ExhibitionState>((ref) {
  final uid = ref.watch(uidProvider);
  return ExhibitionManagementController(
    uid: uid,
    collectionPath: 'exhibitions',
    dbService: DBService(),
  );
});

class ExhibitionManagementController extends StateNotifier<ExhibitionState>
    with StateNotifierSubscriptionMixin {
  ExhibitionManagementController({
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
    subscriptions = dbService.collection$(
      path: collectionPath,
      converter: (id, map) => Exhibition.fromMap({'id': id, ...?map}),
      where: [Where('manager_id', '==', uid)],
    ).listen((event) {
      if (!mounted) return;
      state = ExhibitionState.data(event);
    });
  }

  /// CRUD Operations
  Future<void> createNewExhibition({
    required String name,
    required String description,
    required String imageURL,
    required String address,
    required String phone,
    required String email,
    required List<String> artworkIds,
    required ExhibitionStatus status,
    required DateTimeRange range,
    required double price,
  }) async {
    await dbService.create(
      prefix: 'e',
      collectionPath: collectionPath,
      data: Exhibition.creationModel(
        managerId: uid,
        name: name,
        artworkIds: artworkIds,
        phone: phone,
        email: email,
        description: description,
        imageURL: imageURL,
        status: status,
        dateRange: range,
        address: address,
        price: price,
      ),
    );
  }

  Future<Exhibition?> getExhibition({String? id}) async {
    if (id == null) return null;
    final exhibitions = await first;
    return exhibitions.firstWhereOrNull((exhibition) {
      return exhibition.id == id;
    });
  }

  Future<void> saveExhibition(Exhibition exhibition) async {
    await dbService.set(
      path: '$collectionPath/${exhibition.id}',
      data: exhibition.toMap(),
    );
  }

  Future<void> deleteExhibition(String id) async {
    await dbService.delete(path: '$collectionPath/$id');
  }
}

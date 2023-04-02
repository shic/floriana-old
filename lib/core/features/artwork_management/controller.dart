import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/services/db_service.dart';
import 'package:myguide/core/utils/async.dart';

typedef ArtworkState = AsyncValue<Iterable<Artwork>>;

final artworkManagementProvider = StateNotifierProvider.autoDispose<
    ArtworkManagementController, ArtworkState>((ref) {
  final uid = ref.watch(uidProvider);
  return ArtworkManagementController(
    uid: uid,
    collectionPath: 'artworks',
    dbService: DBService(),
  );
});

class ArtworkManagementController extends StateNotifier<ArtworkState>
    with StateNotifierSubscriptionMixin {
  ArtworkManagementController({
    required this.uid,
    required this.collectionPath,
    required this.dbService,
  }) : super(const ArtworkState.loading()) {
    initialize();
  }

  final String uid;
  final String collectionPath;
  final DBService dbService;

  void initialize() async {
    subscriptions = dbService.collection$(
      path: collectionPath,
      converter: (id, map) => Artwork.fromMap({'id': id, ...?map}),
      where: [Where('manager_id', '==', uid)],
    ).listen((event) {
      if (!mounted) return;
      state = ArtworkState.data(event);
    });
  }

  Future<Artwork?> getArtwork({String? id}) async {
    if (id == null) return null;
    return dbService.doc(
      path: '$collectionPath/$id',
      converter: (id, map) => Artwork.fromMap({'id': id, ...?map}),
    );
  }

  Future<Iterable<Artwork>> getArtworks({required List<String> ids}) async {
    return dbService.collection(
      path: collectionPath,
      converter: (id, map) => Artwork.fromMap({'id': id, ...?map}),
      where: [Where.documentIdWhereIn(target: ids)],
    );
  }

  /// CRUD Operations
  Future<void> createNewArtwork({
    required String name,
    String? description,
    required ArtworkSize size,
    required List<String> images,
    String? material,
    required ArtworkStatus status,
    String? place,
    String? authorId,
    String? openSeaURL,
    String? year,
  }) async {
    await dbService.create(
      prefix: 'a',
      collectionPath: collectionPath,
      data: Artwork.creationModel(
        managerId: uid,
        name: name,
        authorId: authorId,
        description: description,
        artworkSize: ArtworkSize(
            width: size.width, height: size.height, depth: size.depth),
        images: images,
        material: material,
        status: status,
        place: place,
        openSeaURL: openSeaURL,
        year: year,
      ),
    );
  }

  Future<void> saveArtwork(Artwork artwork) async {
    await dbService.set(
      path: '$collectionPath/${artwork.id}',
      data: artwork.toMap(),
    );
  }

  Future<void> deleteArtwork(String id) async {
    await dbService.delete(path: '$collectionPath/$id');
  }
}

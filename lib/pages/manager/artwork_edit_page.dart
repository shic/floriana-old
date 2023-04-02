import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/artwork_management/controller.dart';
import 'package:myguide/core/features/artwork_management/domain.dart';
import 'package:myguide/core/features/artwork_management/ui/artwork_form.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/core/features/author_management/controller.dart';
import 'package:myguide/core/features/author_management/domain.dart';
import 'package:myguide/core/utils/async.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/ui/empty_state.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

final artworkAndAuthorDataProvider = FutureProvider.autoDispose
    .family<MapEntry<Artwork?, Iterable<Author>>, String?>((ref, id) async {
  return await MultiFuture.double(
    id == 'create'
        ? Future.value(null)
        : ref.watch(artworkManagementProvider.notifier).getArtwork(id: id),
    ref.watch(authorManagementProvider.notifier).first,
  );
});

class ArtworkEditPage extends StatelessWidget {
  const ArtworkEditPage({
    super.key,
    required this.id,
  });

  final String? id;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.artwork),
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).padding +
            defaultTargetPlatform.when(
              context: context,
              mobile: AppInsets.page,
              desktop: AppInsets.hpage +
                  EdgeInsets.fromLTRB(
                    0,
                    0,
                    MediaQuery.of(context).size.width * .2,
                    AppSize.xxl,
                  ),
            ),
        child: AuthRequired.manager(
          child: Consumer(
            builder: (_, ref, __) {
              final asyncArtworkAndAuthors =
                  ref.watch(artworkAndAuthorDataProvider(id));
              return asyncArtworkAndAuthors.when(
                data: (artworkAndAuthors) {
                  final artwork = artworkAndAuthors.key;
                  final authors = artworkAndAuthors.value;
                  return ArtworkForm(
                    authors: authors,
                    name: artwork?.name,
                    description: artwork?.description,
                    images: artwork?.images,
                    material: artwork?.material,
                    size: artwork?.size,
                    status: artwork?.status,
                    author: artwork?.authorId,
                    place: artwork?.place,
                    year: artwork?.year,
                    openSeaURL: artwork?.openSeaURL,
                    onSubmit: (artworkValue) async {
                      final router = GoRouter.of(context);
                      final images =
                          List<String>.from(artworkValue.images.whereNotNull());
                      if (artwork == null) {
                        await ref
                            .read(artworkManagementProvider.notifier)
                            .createNewArtwork(
                              authorId: artworkValue.author,
                              name: artworkValue.name!,
                              openSeaURL: artworkValue.openSeaURL,
                              description: artworkValue.description,
                              place: artworkValue.place,
                              size: artworkValue.size,
                              images: images,
                              material: artworkValue.material,
                              status: artworkValue.status,
                              year: artworkValue.year,
                            );
                      } else {
                        final newArtwork = Artwork(
                          id: artwork.id,
                          managerId: artwork.managerId,
                          authorId: artworkValue.author,
                          name: artworkValue.name!,
                          openSeaURL: artworkValue.openSeaURL,
                          description: artworkValue.description,
                          place: artworkValue.place,
                          size: artworkValue.size,
                          images: images,
                          material: artworkValue.material,
                          status: artworkValue.status,
                          year: artworkValue.year,
                          likes: artwork.likes,
                        );
                        await ref
                            .read(artworkManagementProvider.notifier)
                            .saveArtwork(newArtwork);
                      }
                      router.pop();
                    },
                  );
                },
                error: (e, _) => EmptyState.error(message: e.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}

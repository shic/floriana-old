import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/user_controller.dart';
import 'package:myguide/core/features/favorite/controller.dart';
import 'package:myguide/core/utils/async.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

final _artExhProvider = FutureProvider.autoDispose((ref) async {
  final favorites = await ref.watch(favoritesProvider.notifier).first;

  final exhAndArt = await MultiFuture.double(
    ref.watch(userExhibitionsProvider.notifier).first,
    ref.watch(artworkManagementProvider.notifier).first,
  );
  return [
    ...exhAndArt.key.where((e) => favorites.contains(e.id)),
    ...exhAndArt.value.where((e) => favorites.contains(e.id)),
  ];
});

class FavoriteListPage extends ConsumerWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.favorites),
      body: AuthRequired.user(
        child: AppConsumerListWidget(
          provider: _artExhProvider,
          padding: MediaQuery.of(context).padding +
              defaultTargetPlatform.when(
                context: context,
                mobile: AppInsets.page,
                desktop: AppInsets.hpage +
                    EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * .2,
                      bottom: AppSize.m,
                    ),
              ),
          dataBuilder: (_, data) {
            final exh = data.whereType<Exhibition>()
                .sorted(
                  (e1, e2) => e1.dateRange.start.compareTo(e1.dateRange.end),
                )
                .where((element) => element.status == ExhibitionStatus.visible);
            final art = data.whereType<Artwork>().where(
                  (element) => element.status == ArtworkStatus.visible,
                );
            return [
              if (exh.isNotEmpty)
                SliverList(
                  delegate: ExhibitionsChildBuilderDelegate(
                    exhibitions: exh,
                    itemBuilder: (exhibition) {
                      return ExhibitionItem(
                        exhibition: exhibition,
                        onPressed: () =>
                            context.go('/exhibitions/${exhibition.id}'),
                      );
                    },
                  ),
                ),
              if (art.isNotEmpty)
                SliverList(
                  delegate: ArtworksChildBuilderDelegate(
                    artworks: art,
                    itemBuilder: (artwork) {
                      return ArtworkExhibitionItem(
                        artwork: artwork,
                        onPressed: () => context.go('/artworks/${artwork.id}'),
                      );
                    },
                  ),
                ),
            ];
          },
        ),
      ),
    );
  }
}

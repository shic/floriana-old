import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/author_management/ui/author_name.dart';
import 'package:myguide/core/features/favorite/ui/favorite_button.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/descriptive_text.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

final _artworkByIdProvider =
    FutureProvider.family.autoDispose<Artwork?, String>((ref, id) {
  return ref.watch(artworkManagementProvider.notifier).getArtwork(id: id);
});

final _artworkLikeCount =
    StateProvider.family.autoDispose<int?, String>((ref, id) {
  return ref.watch(_artworkByIdProvider(id)).maybeWhen(
    data: (artwork) => artwork?.likes,
    orElse: () => null,
  );
});

class ArtworkDetailPage extends StatelessWidget {
  const ArtworkDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.artwork),
      body: AppConsumerWidget(
        provider: _artworkByIdProvider(id),
        dataBuilder: (context, artwork) {
          if (artwork == null) return const SizedBox();
          String? creationInfoString;
          final creationInfo = [
            if (artwork.year != null) artwork.year,
            if (artwork.place != null) artwork.place,
          ];
          if (creationInfo.isNotEmpty) {
            creationInfoString = creationInfo.join(', ');
          }

          return SingleChildScrollView(
            padding: MediaQuery.of(context).padding +
                defaultTargetPlatform.when(
                  context: context,
                  mobile: EdgeInsets.zero,
                  desktop: AppInsets.hpage +
                      EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * .2,
                        bottom: AppSize.m,
                      ),
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: BlurredBackgroundImage(url: artwork.images.first),
                ),
                const AppSpacer.s(),
                Padding(
                  padding: defaultTargetPlatform.when(
                    context: context,
                    mobile: AppInsets.hpage,
                    desktop: EdgeInsets.zero,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SelectableText(artwork.name, style: textTheme.hM),
                      Row(
                        children: [
                          const Spacer(),
                          Consumer(builder: (_, ref, __) {
                            final count =
                                ref.watch(_artworkLikeCount(artwork.id));
                            if (count == null) return const SizedBox();
                            return FavoriteButton(
                              id: artwork.id,
                              count: count,
                              onComplete: () => ref.refresh(_artworkByIdProvider(artwork.id)),
                            );
                          }),
                        ],
                      ),
                      const Divider(height: AppSize.l),
                      if (artwork.description != null)
                        SelectableText(
                          artwork.description!,
                          style: textTheme.bL,
                        ),
                      const AppSpacer.m(),
                      InformationHolder(
                        infos: [
                          AuthorName(authorId: artwork.authorId),
                          if (creationInfoString != null)
                            DescriptiveText(
                                title: copy.date, content: creationInfoString),
                          if (artwork.material != null)
                            DescriptiveText(
                              title: copy.material,
                              content: artwork.material!,
                            ),
                          if (artwork.size.toString().isNotEmpty)
                            DescriptiveText(
                              title: copy.sizeInCentimeters,
                              content: artwork.size.toString(),
                            ),
                          if (artwork.openSeaURL != null)
                            DescriptiveText(
                              title: copy.openSeaURL,
                              content: artwork.openSeaURL!,
                              link: artwork.openSeaURL,
                            ),
                        ],
                      ),
                      const AppSpacer.m(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

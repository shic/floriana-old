import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/user_controller.dart';
import 'package:myguide/core/features/favorite/ui/favorite_button.dart';
import 'package:myguide/core/features/user_management/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_user.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/descriptive_text.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spaced.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

final _exhibitionByIdProvider =
    FutureProvider.family.autoDispose<Exhibition?, String>((ref, id) {
  final userExh = ref.watch(userExhibitionsProvider.notifier);
  return userExh.getExhibition(id: id);
});

final _exhLikeCountProvider =
    StateProvider.family.autoDispose<int?, String>((ref, id) {
  return ref.watch(
    userExhibitionsProvider.select((value) {
      return value.asData?.value.firstWhereOrNull((e) => e.id == id)?.likes;
    }),
  );
});

final _managerByIdProvider =
    FutureProvider.family.autoDispose<User, String>((ref, id) {
  return ref.watch(userProvider.notifier).getUserById(id);
});

final _exhibitionsArtworksProvider = FutureProvider.family
    .autoDispose<Iterable<Artwork>, Exhibition>((ref, exhibition) {
  return ref.watch(artworkManagementProvider.notifier).getArtworks(
        ids: exhibition.artworkIds,
      );
});

class ExhibitionDetailPage extends StatelessWidget {
  const ExhibitionDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.exhibition),
      body: AppConsumerWidget(
        provider: _exhibitionByIdProvider(id),
        dataBuilder: (context, exhibition) {
          if (exhibition == null) return const SizedBox();
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;
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
                  child: BlurredBackgroundImage(url: exhibition.imageURL!),
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
                      SelectableText(exhibition.name, style: textTheme.hM),
                      Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Consumer(builder: (_, ref, __) {
                            final count =
                                ref.watch(_exhLikeCountProvider(exhibition.id));
                            if (count == null) return const SizedBox();
                            return FavoriteButton(
                              id: exhibition.id,
                              count: count,
                              onComplete: () => ref.refresh(
                                  _exhibitionByIdProvider(exhibition.id)),
                            );
                          }),
                        ],
                      ),
                      const AppSpacer.xs(),
                      Consumer(
                        builder: (_, ref, __) {
                          final manager = ref
                              .watch(
                                _managerByIdProvider(exhibition.managerId),
                              )
                              .asData;
                          if (manager == null) return const SizedBox();
                          return Row(
                            children: [
                              if (manager.value.avatar?.isNotEmpty ?? true)
                                Container(
                                  height: 35,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: CachedNetworkImage(
                                    height: 30,
                                    imageUrl: manager.value.avatar!,
                                  ),
                                ),
                              if (manager.value.displayName?.isNotEmpty ??
                                  true) ...[
                                const AppSpacer.s(),
                                Expanded(
                                  child: Text(
                                    copy.organizedBy(
                                        manager.value.displayName!),
                                    style: theme.textTheme.hS.copyWith(
                                      color: theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSize.s),

                      const Divider(height: AppSize.s),

                      // introduction
                      const SizedBox(height: AppSize.s),
                      SelectableText(exhibition.description,
                          style: textTheme.bL),

                      // info
                      const AppSpacer.m(),
                      InformationHolder(
                        infos: [
                          DescriptiveText(
                            title: copy.date,
                            content: copy
                                .fromToMMMMd(
                                  exhibition.dateRange.start.toUtc(),
                                  exhibition.dateRange.end.toUtc(),
                                )
                                .toUpperCase(),
                          ),
                          DescriptiveText(
                            title: copy.address,
                            content: exhibition.address,
                          ),
                          if (exhibition.email != null)
                            DescriptiveText(
                              title: copy.email,
                              content: exhibition.email!,
                            ),
                          if (exhibition.phone != null)
                            DescriptiveText(
                              title: copy.phoneNumber,
                              content: exhibition.phone!,
                            ),
                          DescriptiveText(
                            title: copy.cost,
                            content: copy.costInMoney(exhibition.price ?? 0),
                          ),
                        ],
                      ),

                      const AppSpacer.m(),
                      // Artworks
                      AppConsumerWidget(
                        provider: _exhibitionsArtworksProvider(exhibition),
                        dataBuilder: (_, artworks) {
                          final filtered = artworks.where((element) =>
                              element.status == ArtworkStatus.visible);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(copy.artworks, style: theme.textTheme.tL),
                              const AppSpacer.s(),
                              defaultTargetPlatform.when(
                                context: context,
                                mobile: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    filtered.length,
                                    (index) {
                                      final artwork = filtered.elementAt(index);
                                      return ArtworkExhibitionItem(
                                        artwork: artwork,
                                        onPressed: () {
                                          context.go(
                                            ArtworkDetailRoute.route(
                                              id: artwork.id,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ).separated(
                                    separatorBuilder: () => const AppSpacer.s(),
                                  ),
                                ),
                                desktop: Wrap(
                                  runSpacing: AppSize.s,
                                  spacing: AppSize.l,
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                    filtered.length,
                                    (index) {
                                      final artwork =
                                      filtered.elementAt(index);
                                      return ArtworkExhibitionItem(
                                        artwork: artwork,
                                        onPressed: () {
                                          context.go(
                                            ArtworkDetailRoute.route(
                                              id: artwork.id,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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

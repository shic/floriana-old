import 'package:flutter/material.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/author_management/ui/author_name.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/qr_download_button.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class ArtworksChildBuilderDelegate extends SliverChildBuilderDelegate {
  ArtworksChildBuilderDelegate({
    required Iterable<Artwork> artworks,
    required Widget Function(Artwork) itemBuilder,
  }) : super(
          (_, i) {
            if (i.isOdd) return const AppSpacer.s();
            final artwork = artworks.elementAt(i ~/ 2);
            return itemBuilder(artwork);
          },
          childCount: artworks.length * 2 - 1,
          semanticIndexCallback: (_, i) => i.isEven ? i ~/ 2 : null,
        );
}

class ArtworkDashboardListItem extends StatelessWidget {
  const ArtworkDashboardListItem({
    super.key,
    required this.artwork,
    required this.onEdit,
    required this.onDelete,
  });

  final Artwork artwork;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final infos = <String>[
      if (artwork.status == ArtworkStatus.invisible) copy.notVisible,
      if (artwork.images.isEmpty) copy.imagesNotSet,
      if (artwork.authorId == null) copy.authorNotSet,
    ];
    return DashboardListItem(
      title: artwork.name,
      infos: infos.isEmpty ? null : infos,
      actions: [
        QRDownloadButton(
          fileName: artwork.name,
          url: '${Uri.base.origin}/artworks/${artwork.id}',
        ),
        EditDashboardItemButton(onEdit: onEdit),
        DeleteDashboardItemButton(onDelete: onDelete),
      ],
    );
  }
}

class ArtworkFavoriteItem extends StatelessWidget {
  const ArtworkFavoriteItem({
    super.key,
    required this.artwork,
    this.onPressed,
    this.isLikeAllowed = true,
  });

  final Artwork artwork;
  final VoidCallback? onPressed;
  final bool isLikeAllowed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1.75,
                child: Image.network(
                  artwork.images.first,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Text(artwork.name, style: textTheme.dM),
              Text(artwork.description ?? '', style: textTheme.hL),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtworkExhibitionItem extends StatelessWidget {
  const ArtworkExhibitionItem({
    super.key,
    required this.artwork,
    this.onPressed,
  });

  final Artwork artwork;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SizedBox(
      width: 200,
      child: Material(
        color: colorScheme.background,
        elevation: 1,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppInsets.vs,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: BlurredBackgroundImage(url: artwork.images.first),
                ),
              ),
              Padding(
                padding: AppInsets.hs,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(artwork.name, style: textTheme.tM, maxLines: 2),
                    AuthorName(authorId: artwork.authorId),
                    const AppSpacer.s(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

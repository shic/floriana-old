import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/pages/utils/provider.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_manager.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class ArtworkListPage extends StatelessWidget {
  const ArtworkListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(
        title: copy.artworks,
        actions: [
          CreateNewButton(
            path: ArtworkEditRoute.route(),
          ),
        ],
      ),
      body: AuthRequired.manager(
        child: AppConsumerListWidget(
          provider: artworkManagementProvider,
          padding: MediaQuery.of(context).padding +
              defaultTargetPlatform.when(
                context: context,
                mobile: AppInsets.page,
                desktop: AppInsets.hpage +
                    EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * .2,
                    ),
              ),
          dataBuilder: (_, artworks) {
            return [
              SliverList(
                delegate: ArtworksChildBuilderDelegate(
                  artworks: artworks,
                  itemBuilder: (artwork) {
                    return ArtworkDashboardListItem(
                      artwork: artwork,
                      onEdit: () {
                        context.go(ArtworkEditRoute.route(id: artwork.id));
                      },
                      onDelete: () {
                        context
                            .read(artworkManagementProvider.notifier)
                            .deleteArtwork(artwork.id);
                      },
                    );
                  },
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}

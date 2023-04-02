import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/qr_download_button.dart';
import 'package:myguide/ui/spacers.dart';

class ExhibitionsChildBuilderDelegate extends SliverChildBuilderDelegate {
  ExhibitionsChildBuilderDelegate({
    required Iterable<Exhibition> exhibitions,
    required Widget Function(Exhibition) itemBuilder,
  }) : super(
          (_, i) {
            if (i.isOdd) return const AppSpacer.s();
            final exhibition = exhibitions.elementAt(i ~/ 2);
            return itemBuilder(exhibition);
          },
          childCount: max(0, exhibitions.length * 2 - 1),
          semanticIndexCallback: (_, i) => i.isEven ? i ~/ 2 : null,
        );
}

class ExhibitionDashboardListItem extends StatelessWidget {
  const ExhibitionDashboardListItem({
    super.key,
    required this.exhibition,
    required this.onEdit,
    required this.onDelete,
  });

  final Exhibition exhibition;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    final infos = <String>[
      if (exhibition.status == ExhibitionStatus.invisible) copy.notVisible,
      if (exhibition.imageURL == null) copy.imagesNotSet,
      if (exhibition.artworkIds.isEmpty) copy.noArtworkAdded,
    ];
    return DashboardListItem(
      title: exhibition.name,
      infos: infos.isEmpty ? null : infos,
      actions: [
        QRDownloadButton(
          fileName: exhibition.id,
          url: '${Uri.base.origin}/exhibitions/${exhibition.id}',
        ),
        EditDashboardItemButton(onEdit: onEdit),
        DeleteDashboardItemButton(onDelete: onDelete),
      ],
    );
  }
}

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/user_controller.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_user.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class ExhibitionListPage extends ConsumerWidget {
  const ExhibitionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.exhibitions),
      body: AppConsumerListWidget(
        provider: userExhibitionsProvider,
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
        dataBuilder: (_, exhibitions) {
          final ordered = exhibitions.sorted(
            (e1, e2) => e1.dateRange.start.compareTo(e1.dateRange.end),
          );
          return [
            SliverList(
              delegate: ExhibitionsChildBuilderDelegate(
                exhibitions: ordered,
                itemBuilder: (exhibition) {
                  return ExhibitionItem(
                    exhibition: exhibition,
                    onPressed: () {
                      context.go(
                        ExhibitionDetailRoute.route(id: exhibition.id),
                      );
                    },
                  );
                },
              ),
            ),
          ];
        },
      ),
    );
  }
}

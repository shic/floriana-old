import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/monuments_management/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_user.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class MonumentListPage extends ConsumerWidget {
  const MonumentListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.monuments),
      body: AppConsumerListWidget(
        provider: monumentManagementProvider,
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
        dataBuilder: (_, monuments) {
          return [
            SliverList(
              delegate: MonumentsChildBuilderDelegate(
                monuments: monuments,
                itemBuilder: (monument) {
                  return MonumentItem(
                    monument: monument,
                    onPressed: () async {
                      context.go( MonumentDetailRoute.route(id: monument.id));
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

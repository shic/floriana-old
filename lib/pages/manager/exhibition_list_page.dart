import 'dart:convert';

import 'package:barcode/barcode.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/core/services/qr_service.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/pages/utils/provider.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/routing/routes_manager.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class ExhibitionListPage extends StatelessWidget {
  const ExhibitionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(
        title: copy.exhibitions,
        actions: [
          CreateNewButton(path: ExhibitionEditRoute.route()),
        ],
      ),
      body: AuthRequired.manager(
        child: AppConsumerListWidget(
          provider: exhibitionManagementProvider,
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
          dataBuilder: (_, exhibitions) {
            return [
              SliverList(
                delegate: ExhibitionsChildBuilderDelegate(
                  exhibitions: exhibitions,
                  itemBuilder: (exhibition) {
                    return ExhibitionDashboardListItem(
                      exhibition: exhibition,
                      onDelete: () {
                        context
                            .read(exhibitionManagementProvider.notifier)
                            .deleteExhibition(exhibition.id);
                      },
                      onEdit: () => context.go(
                        ExhibitionEditRoute.route(id: exhibition.id),
                      ),
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

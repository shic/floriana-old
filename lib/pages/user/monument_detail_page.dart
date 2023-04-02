import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/monuments_management/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

final _monumentByIdProvider =
    FutureProvider.family.autoDispose<Monument?, String>((ref, id) {
  final userExh = ref.watch(monumentManagementProvider.notifier);
  return userExh.getMonument(id: id);
});

class MonumentDetailPage extends StatelessWidget {
  const MonumentDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.monument),
      body: AppConsumerWidget(
        provider: _monumentByIdProvider(id),
        dataBuilder: (context, monument) {
          if (monument == null) return const SizedBox();
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
                  child: BlurredBackgroundImage(url: monument.imageURL!),
                ),
                const AppSpacer.xs(),
                Padding(
                  padding: defaultTargetPlatform.when(
                    context: context,
                    mobile: AppInsets.hpage,
                    desktop: EdgeInsets.zero,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SelectableText(monument.name, style: textTheme.hM),
                      Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                      const AppSpacer.xs(),

                      const Divider(height: AppSize.s),

                      // introduction
                      const SizedBox(height: AppSize.s),
                      SelectableText(monument.description, style: textTheme.bL),

                      // info
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/user_controller.dart';
import 'package:myguide/core/features/user_management/all.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).asData?.value;
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.home),
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
          return [
            SliverList(
              delegate: ExhibitionsChildBuilderDelegate(
                exhibitions: exhibitions.take(3),
                itemBuilder: (exhibition) {
                  return ExhibitionItem(
                    exhibition: exhibition,
                    onPressed: () =>
                        context.go('/exhibitions/${exhibition.id}'),
                    isLikeAllowed: user != null,
                  );
                },
              ),
            ),
            if (exhibitions.length > 3) ...[
              const SliverToBoxAdapter(child: AppSpacer.m()),
              SliverToBoxAdapter(
                child: ElevatedButton(
                  child: Text(copy.showMore),
                  onPressed: () => context.go('/exhibitions'),
                ),
              ),
            ],
          ];
        },
      ),
    );
  }
}

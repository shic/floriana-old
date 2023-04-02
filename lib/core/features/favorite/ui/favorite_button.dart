import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/authentication/all.dart';
import 'package:myguide/core/features/favorite/all.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/ui/dialog.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.id,
    required this.count,
    required this.onComplete,
  });

  final String id;
  final int count;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.value!.contains(id);
    return Material(
      color: theme.colorScheme.background,
      elevation: 1,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (ref.read(authProvider).isAnonymous) {
            context.push(AuthRoute.route());
            return;
          }
          final favoritesController = ref.read(favoritesProvider.notifier);
          context.guardThrowable(
            operation: () async {
              if (isFavorite) {
                await favoritesController.removeFavorite(id);
              } else {
                await favoritesController.addFavorite(id);
              }
              onComplete();
            },
          );
        },
        child: Padding(
          padding: AppInsets.hs,
          child: Row(
            children: [
              Icon(
                isFavorite
                    ? Icons.thumb_up_off_alt_sharp
                    : Icons.thumb_up_off_alt_outlined,
                color: theme.colorScheme.tertiary,
              ),
              const VerticalDivider(width: AppSize.xs),
              Text((count.isNegative ? 0: count).toString(), style: theme.textTheme.tS),
            ],
          ),
        ),
      ),
    );
  }
}

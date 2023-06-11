import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/exhibitions_management/user_controller.dart';
import 'package:myguide/core/features/favorite/controller.dart';
import 'package:myguide/core/utils/async.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/scaffold/appbar.dart';

final _artExhProvider = FutureProvider.autoDispose((ref) async {
  final favorites = await ref.watch(favoritesProvider.notifier).first;

  final exhAndArt = await MultiFuture.double(
    ref.watch(userExhibitionsProvider.notifier).first,
    ref.watch(artworkManagementProvider.notifier).first,
  );
  return [
    ...exhAndArt.key.where((e) => favorites.contains(e.id)),
    ...exhAndArt.value.where((e) => favorites.contains(e.id)),
  ];
});

class FavoriteListPage extends ConsumerWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppAppBar(title: copy.favorites),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: AppImage(
            url: 'assets/home.jpeg',
          ),
        ));
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myguide/core/features/artwork_management/all.dart';
import 'package:myguide/core/features/authentication/ui/auth_required_content.dart';
import 'package:myguide/core/features/exhibitions_management/all.dart';
import 'package:myguide/core/utils/async.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/ui/empty_state.dart';
import 'package:myguide/ui/responsive_widget.dart';
import 'package:myguide/ui/scaffold/appbar.dart';
import 'package:myguide/ui/spacers.dart';

final exhibitionAndArtworksDataProvider = FutureProvider.autoDispose
    .family<MapEntry<Exhibition?, Iterable<Artwork>>, String?>((ref, id) async {
  return await MultiFuture.double(
    ref.watch(exhibitionManagementProvider.notifier).getExhibition(id: id),
    ref.watch(artworkManagementProvider.notifier).first,
  );
});

class ExhibitionEditPage extends StatelessWidget {
  const ExhibitionEditPage({
    super.key,
    required this.id,
  });

  final String? id;

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: copy.exhibition),
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).padding +
            defaultTargetPlatform.when(
              context: context,
              mobile: AppInsets.page,
              desktop: AppInsets.hpage +
                  EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * .2,
                    bottom: AppInsets.page.bottom,
                  ),
            ),
        child: AuthRequired.manager(
          child: Consumer(
            builder: (_, ref, __) {
              final exhibition =
                  ref.watch(exhibitionAndArtworksDataProvider(id));
              return exhibition.when(
                data: (exhibitionAndArtworks) {
                  final data = exhibitionAndArtworks.key;
                  if (data == null) {
                    return ExhibitionForm(
                      artworks: exhibitionAndArtworks.value,
                      onSubmit: (value) async {
                        final router = GoRouter.of(context);
                        await ref
                            .read(exhibitionManagementProvider.notifier)
                            .createNewExhibition(
                              name: value.name,
                              artworkIds: value.artworkIds,
                              description: value.description,
                              phone: value.phone,
                              email: value.email,
                              imageURL: value.imageURL!,
                              status: value.exhibitionStatus,
                              address: value.address,
                              range: value.dateTimeRange!,
                              price: value.price!,
                            );
                        router.pop();
                      },
                    );
                  }
                  return ExhibitionForm(
                    initialValue: ExhibitionFormValue(
                      name: data.name,
                      description: data.description,
                      imageURL: data.imageURL,
                      exhibitionStatus: data.status,
                      artworkIds: data.artworkIds,
                      phone: data.phone ?? '',
                      email: data.email ?? '',
                      dateTimeRange: data.dateRange,
                      address: data.address,
                      price: data.price,
                    ),
                    artworks: exhibitionAndArtworks.value,
                    onSubmit: (exhibitionValue) async {
                      final router = GoRouter.of(context);
                      await ref
                          .read(exhibitionManagementProvider.notifier)
                          .saveExhibition(
                            data.copyWith(
                              name: exhibitionValue.name,
                              description: exhibitionValue.description,
                              imageURL: exhibitionValue.imageURL,
                              dateRange: exhibitionValue.dateTimeRange,
                              phone: exhibitionValue.phone,
                              email: exhibitionValue.email,
                              status: exhibitionValue.exhibitionStatus,
                              artworkIds: exhibitionValue.artworkIds,
                              address: exhibitionValue.address,
                              price: exhibitionValue.price,
                            ),
                          );
                      router.pop();
                    },
                  );
                },
                error: (e, s) => EmptyState.error(
                  message: '$e $s',
                ),
                loading: () => const EmptyState.loading(),
              );
            },
          ),
        ),
      ),
    );
  }
}

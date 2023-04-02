import 'package:flutter/material.dart';
import 'package:myguide/core/features/exhibitions_management/domain.dart';
import 'package:myguide/l10n/l10n.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class ExhibitionItem extends StatelessWidget {
  const ExhibitionItem({
    super.key,
    required this.exhibition,
    required this.onPressed,
    this.isLikeAllowed = true,
  });

  final Exhibition exhibition;
  final VoidCallback onPressed;
  final bool isLikeAllowed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final copy = AppLocalizations.of(context)!;
    final textTheme = theme.textTheme;

    return Material(
      color: theme.colorScheme.background,
      elevation: 1,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          children: [
            Padding(
              padding: AppInsets.vs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: AppInsets.hxs,
                    child: AspectRatio(
                      aspectRatio: 1.75,
                      child: exhibition.imageURL == null
                          ? null
                          : BlurredBackgroundImage(url: exhibition.imageURL!),
                    ),
                  ),
                  const AppSpacer.s(),
                  Padding(
                    padding: AppInsets.hm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          exhibition.name,
                          style: textTheme.tL,
                        ),
                        const SizedBox(height: AppSize.xs),
                        Text(
                          copy.fromToMMMMd(
                            exhibition.dateRange.start.toUtc(),
                            exhibition.dateRange.end.toUtc(),
                          ).toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

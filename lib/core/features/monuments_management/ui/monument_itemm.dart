import 'package:flutter/material.dart';
import 'package:myguide/core/features/monuments_management/domain.dart';
import 'package:myguide/ui/app_image.dart';
import 'package:myguide/ui/spacers.dart';
import 'package:myguide/ui/theme.dart';

class MonumentItem extends StatelessWidget {
  const MonumentItem({
    super.key,
    required this.monument,
    required this.onPressed,
    this.isLikeAllowed = true,
  });

  final Monument monument;
  final VoidCallback onPressed;
  final bool isLikeAllowed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      child: BlurredBackgroundImage(url: monument.imageURL),
                    ),
                  ),
                  const AppSpacer.s(),
                  Padding(
                    padding: AppInsets.hm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectableText(
                          monument.name,
                          style: textTheme.tL,
                        ),
                        const SizedBox(height: AppSize.xs),
                        Text(
                          monument.address,
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

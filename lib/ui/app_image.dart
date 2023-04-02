import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlurredBackgroundImage extends StatelessWidget {
  BlurredBackgroundImage({
    super.key,
    required String url,
/*
  }) : provider = CachedNetworkImageProvider(
          url.replaceFirst('?alt=media', '_1920x1080?alt=media'),
        );
*/

  }) : provider = CachedNetworkImageProvider(url);

  final CachedNetworkImageProvider provider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image(image: provider, fit: BoxFit.cover)),
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.8)),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Image(image: provider, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}

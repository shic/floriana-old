import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myguide/core/features/monuments_management/all.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/ui/list.dart';
import 'package:myguide/ui/spacers.dart';

class MonumentsChildBuilderDelegate extends SliverChildBuilderDelegate {
  MonumentsChildBuilderDelegate({
    required Iterable<Monument> monuments,
    required Widget Function(Monument) itemBuilder,
  }) : super(
          (_, i) {
            if (i.isOdd) return const AppSpacer.s();
            final monument = monuments.elementAt(i ~/ 2);
            return itemBuilder(monument);
          },
          childCount: max(0, monuments.length * 2 - 1),
          semanticIndexCallback: (_, i) => i.isEven ? i ~/ 2 : null,
        );
}


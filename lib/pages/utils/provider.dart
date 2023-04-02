import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension Riverpod on BuildContext {
  T read<T>(ProviderListenable<T> provider) => ProviderScope.containerOf(
        this,
        listen: false,
      ).read(provider);
}

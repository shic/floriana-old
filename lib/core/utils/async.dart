import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin StateNotifierSubscriptionMixin<T> on StateNotifier<T> {
  final _subscriptions = <StreamSubscription>[];

  set subscriptions(StreamSubscription s) {
    _subscriptions.add(s);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}

extension StateNotifierFuture<T> on StateNotifier<AsyncValue<T>> {
  Future<T> get first async {
    final completer = Completer<T>();
    final removeListener = addListener(
      (state) {
        state.whenOrNull(
          data: completer.complete,
          error: completer.completeError,
        );
      },
      fireImmediately: true,
    );
    final value = await completer.future;
    removeListener();
    return value;
  }
}

class MultiFuture {
  MultiFuture._();

  static Future<MapEntry<T, V>> double<T, V>(
      Future<T> future1, Future<V> future2) async {
    final results = await Future.wait([future1, future2]);
    return MapEntry(results[0] as T, results[1] as V);
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';

class Awaitable<T> {
  final _initCompleter = Completer<T>();

  @protected
  bool get isInitialized => _initCompleter.isCompleted;

  @protected
  void initializeWithValue(T value) {
    assert(!_initCompleter.isCompleted, 'Awaitable is already initialized!');
    _initCompleter.complete(value);
  }

  Future<T> get ensureInitialized => _initCompleter.future;
}

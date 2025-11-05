import 'package:flutter/foundation.dart';
import 'package:vitals_utils/src/state_stream.dart';
import 'package:vitals_utils/src/stream.dart';
import 'package:vitals_utils/src/stream_map.dart';

abstract class Disposable with CloseableMixin, CancelableMixin {
  late bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  bool get isActive => !_isDisposed;

  StateStream<T> stateOf<T>([T? initValue]) =>
      (initValue != null ? StateStream<T>.seeded(initValue) : StateStream<T>()).closeable(closeable);

  StreamMap<K, V> streamMapOf<K, V>([Map<K, V>? initValue]) => StreamMap<K, V>(initValue).closeable(closeable);

  @mustCallSuper
  void dispose() {
    _isDisposed = true;
    cancelable.dispose();
    closeable.dispose();
  }
}

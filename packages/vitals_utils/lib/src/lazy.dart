import 'dart:async';

SyncLazy<T> lazy<T>(T Function() function) => SyncLazy<T>(function);

AsyncLazy<T> asyncLazy<T>(Future<T> Function() function) => AsyncLazy<T>(function);

abstract class Lazy<T> {
  bool isType<R>();

  Type get type;

  FutureOr<T> get value;

  FutureOr<T> call();

  bool get isInitialized;
}

/// Private
class SyncLazy<T> implements Lazy<T> {
  final T Function() _initializer;
  T? _value;

  bool _isInitialized = false;

  SyncLazy(this._initializer);

  @override
  T call() => value;

  @override
  T get value {
    if (_value == null) {
      _value = _initializer();
      _isInitialized = true;
    }

    return _value!;
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  String toString() => 'Lazy{type: $type, isInitialized: $isInitialized, _value: $_value, _initializer: $_initializer}';

  @override
  Type get type => T;

  @override
  bool isType<R>() => _initializer is R Function();
}

/// Private
class AsyncLazy<T> implements Lazy<T> {
  final Future<T> Function() _initializer;
  T? _value;

  bool _initialized = false;

  AsyncLazy(this._initializer);

  @override
  Future<T> call() => value;

  @override
  Future<T> get value async {
    if (_value == null) {
      _value = await _initializer();
      _initialized = true;
    }
    return _value!;
  }

  @override
  bool get isInitialized => _initialized;

  @override
  String toString() =>
      'AsyncLazy{type: $type, isInitialized: $isInitialized, _value: $_value, _initializer: $_initializer}';

  @override
  Type get type => T;

  @override
  bool isType<R>() => _initializer is Future<R> Function();
}

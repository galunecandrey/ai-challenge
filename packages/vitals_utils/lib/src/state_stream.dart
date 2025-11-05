import 'dart:async';

import 'package:rxdart/rxdart.dart';

class StateStream<T> extends Subject<T> implements ValueStream<T> {
  final _Wrapper<T> _wrapper;

  factory StateStream({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) {
    // ignore: close_sinks
    final controller = StreamController<T>.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );

    return StateStream<T>._(
      controller,
      controller.stream,
      _Wrapper<T>(),
    );
  }

  StateStream._(
    super.controller,
    super.stream,
    this._wrapper,
  );

  factory StateStream.seeded(
    T seedValue, {
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) {
    // ignore: close_sinks
    final controller = StreamController<T>.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: sync,
    );

    final wrapper = _Wrapper<T>.seeded(seedValue);

    return StateStream<T>._(
      controller,
      controller.stream,
      wrapper,
    );
  }

  void addIfAbsent(T event) {
    if (!isClosed && !hasValue) {
      super.add(event);
    }
  }

  void addIfNull(T event) {
    if (!isClosed && valueOrNull == null) {
      super.add(event);
    }
  }

  @override
  void add(T event) {
    if (!isClosed) {
      super.add(event);
    }
  }

  @override
  void onAdd(T event) => _wrapper.setValue(event);

  void clear() => _wrapper.clear();

  @override
  void onAddError(Object error, [StackTrace? stackTrace]) => _wrapper.setError(error, stackTrace);

  Stream<T> call({bool sendFirst = false}) async* {
    if (sendFirst && hasValue) {
      yield value;
    }
    yield* this;
  }

  @override
  Stream<T> get stream => this;

  @override
  bool get hasValue => _wrapper.isValue;

  @override
  T get value => _wrapper.isValue ? _wrapper.value as T : (throw ValueStreamError.hasNoValue());

  @override
  T? get valueOrNull => _wrapper.value;

  /// Set and emit the new value.
  set value(T newValue) => add(newValue);

  @override
  bool get hasError => _wrapper.errorAndStackTrace != null;

  @override
  Object? get errorOrNull => _wrapper.errorAndStackTrace?.error;

  @override
  Object get error => _wrapper.errorAndStackTrace?.error ?? (throw ValueStreamError.hasNoError());

  @override
  StackTrace? get stackTrace => _wrapper.errorAndStackTrace?.stackTrace;
}

class _Wrapper<T> {
  bool isValue;
  T? value;
  ErrorAndStackTrace? errorAndStackTrace;

  /// Non-seeded constructor
  _Wrapper() : isValue = false;

  _Wrapper.seeded(this.value) : isValue = true;

  void setValue(T event) {
    value = event;
    isValue = true;
  }

  void setError(Object error, StackTrace? stackTrace) {
    errorAndStackTrace = ErrorAndStackTrace(error, stackTrace);
    isValue = false;
  }

  void clear() {
    errorAndStackTrace = null;
    value = null;
    isValue = false;
  }
}

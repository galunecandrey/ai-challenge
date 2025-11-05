import 'dart:async';

import 'package:vitals_utils/src/state_stream.dart';

abstract class StreamObject<T> implements StreamController<T> {
  late final StateStream<T> _state;

  T? get stateOrNull => _state.valueOrNull;

  T get state => _state.value;

  set state(T value) {
    _state.add(value);
  }

  StreamObject([T? initValue]) {
    _state = initValue != null ? StateStream.seeded(initValue) : StateStream();
  }

  Stream<T> call({bool sendFirst = false}) => _state.call(sendFirst: sendFirst);

  @override
  FutureOr<void> Function()? get onCancel => _state.onCancel;

  @override
  set onCancel(FutureOr<void> Function()? fun) => _state.onCancel = fun;

  @override
  void Function()? get onListen => _state.onListen;

  @override
  set onListen(FutureOr<void> Function()? fun) => _state.onCancel = fun;

  @override
  void Function()? get onPause => _state.onPause;

  @override
  set onPause(void Function()? fun) => _state.onPause = fun;

  @override
  void Function()? get onResume => _state.onResume;

  @override
  set onResume(void Function()? fun) => _state.onResume = fun;

  @override
  void add(T event) => _state.add(event);

  @override
  void addError(Object error, [StackTrace? stackTrace]) => _state.addError(error, stackTrace);

  @override
  Future<void> addStream(Stream<T> source, {bool? cancelOnError}) => _state.addStream(
        source,
        cancelOnError: cancelOnError,
      );

  @override
  Future<dynamic> close() => _state.close();

  @override
  Future<dynamic> get done => _state.done;

  @override
  bool get hasListener => _state.hasListener;

  @override
  bool get isClosed => _state.isClosed;

  @override
  bool get isPaused => _state.isPaused;

  @override
  StreamSink<T> get sink => _state.sink;

  @override
  Stream<T> get stream => _state.stream;
}

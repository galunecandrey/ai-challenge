import 'package:flutter/foundation.dart';
import 'package:vitals_core/src/api/storage/storage.dart';
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart';

base class MemoryStorage<T> implements Storage<T> {
  MemoryStorage(
    this._operationService, {
    T? initialValue,
  }) : _controller = initialValue != null ? StateStream.seeded(initialValue) : StateStream();

  String _getTag(String method) => 'MemoryStorage<$T>.$method';

  final OperationService _operationService;

  final StateStream<T?> _controller;

  @override
  Either<BaseError, T> call({T? defaultValue}) => _operationService
      .safeSyncOp(
        () => _controller.valueOrNull ?? defaultValue,
        tag: _getTag('get'),
      )
      .emptyStorageIfNull();

  @override
  Either<BaseError, T> get({T? defaultValue}) => call();

  @override
  Either<BaseError, Unit> set(T value) => _operationService.safeUnitSyncOp(
        () {
          _controller.add(value);
        },
        tag: _getTag('set'),
      );

  @override
  Stream<Either<BaseError, T>> stream({bool sendFirst = false}) async* {
    if (sendFirst) {
      yield call();
    }
    yield* _controller.stream.map((event) => event.emptyStorageIfNull());
  }

  @override
  Either<BaseError, Unit> clean() => _operationService.safeUnitSyncOp(
        () {
          _controller.add(null);
        },
        tag: _getTag('clean'),
      );

  @mustCallSuper
  @override
  Future<Either<BaseError, Unit>> close() => _operationService.safeUnitAsyncOp(
        _controller.close,
        tag: _getTag('close'),
      );
}

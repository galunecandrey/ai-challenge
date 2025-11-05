import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vitals_core/src/api/storage/key_storage.dart';
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart';

base class MemoryKeyStorage<K, V> implements KeyStorage<K, V> {
  MemoryKeyStorage(
    this._operationService, {
    Map<K, V>? initialValue,
  }) : _controller = StateStream<Map<K, V>>.seeded(
          {
            if (initialValue != null) ...initialValue,
          },
        );

  String _getTag(String method) => 'MemoryKeyStorage<$K, $V>.$method';

  final OperationService _operationService;

  final StateStream<Map<K, V>> _controller;

  @override
  bool contains(K key) => _controller.value.containsKey(key);

  @override
  Either<BaseError, V> operator [](K key) => call(key);

  @override
  Either<BaseError, V> call(K key, {V? defaultValue}) => _operationService
      .safeSyncOp(
        () => _controller.value[key] ?? defaultValue,
        tag: _getTag('get'),
      )
      .noExistIfNull();

  @override
  Either<BaseError, V> get(K key, {V? defaultValue}) => call(key, defaultValue: defaultValue);

  @override
  Either<BaseError, Map<K, V>> getAll() => _operationService.safeSyncOp(
        () => {
          ..._controller.value,
        },
        tag: _getTag('getAll'),
      );

  @override
  Either<BaseError, Unit> delete(K key) => _operationService.safeUnitSyncOp(
        () => _controller.add(
          {
            ...(_controller.value..remove(key)),
          },
        ),
        tag: _getTag('delete'),
      );

  @override
  Either<BaseError, Unit> deleteKeys(List<K> keys) => _operationService.safeUnitSyncOp(
        () => _controller.add(
          {
            ...(_controller.value
              ..removeWhere(
                (key, value) => keys.contains(key),
              )),
          },
        ),
        tag: _getTag('deleteKeys'),
      );

  @override
  Either<BaseError, Unit> set(K key, V value) => _operationService.safeUnitSyncOp(
        () => _controller.add(
          {...(_controller.value..[key] = value)},
        ),
        tag: _getTag('set'),
      );

  @override
  Either<BaseError, Unit> setAll(Map<K, V> data) => _operationService.safeUnitSyncOp(
        () => _controller.add(
          {..._controller.value}..addAll(data),
        ),
        tag: _getTag('setAll'),
      );

  @override
  Either<BaseError, Unit> replaceAll(Map<K, V> data) => _operationService.safeUnitSyncOp(
        () => _controller.add(
          Map.of(data),
        ),
        tag: _getTag('replaceAll'),
      );

  @override
  Stream<Either<BaseError, Map<K, V>>> streamAll({bool sendFirst = false}) =>
      _streamAll(sendFirst: sendFirst).map((event) => getAll());

  Stream<Map<K, V>> _streamAll({bool sendFirst = false}) async* {
    if (sendFirst) {
      yield _controller.value;
    }
    yield* _controller;
  }

  @override
  Stream<Either<BaseError, V>> streamKey(
    K key, {
    bool sendFirst = false,
  }) =>
      _streamKey(
        key,
        sendFirst: sendFirst,
      ).distinct().map(
            (e) => e.noExistIfNull(),
          );

  Stream<V?> _streamKey(
    K key, {
    bool sendFirst = false,
  }) async* {
    if (sendFirst) {
      yield _controller.value[key];
    }
    yield* _controller.map((v) => v[key]);
  }

  @override
  Stream<Map<K, Either<BaseError, V>>> streamKeys(
    List<K> keys, {
    V? defaultValue,
    bool sendFirst = false,
  }) =>
      _streamAll(sendFirst: sendFirst).distinct((previous, next) {
        for (final key in keys) {
          if (previous[key] != next[key]) {
            return false;
          }
        }
        return true;
      }).map(
        (v) => {
          for (final key in keys) key: call(key, defaultValue: defaultValue),
        },
      );

  @override
  Either<BaseError, Unit> clean() => _operationService.safeUnitSyncOp(
        () => _controller.add({}),
        tag: _getTag('clean'),
      );

  @mustCallSuper
  @override
  Either<BaseError, Unit> close() => _operationService.safeUnitSyncOp(
        _controller.close,
        tag: _getTag('close'),
      );

  @override
  bool get isEmpty => _controller.value.isEmpty;
}

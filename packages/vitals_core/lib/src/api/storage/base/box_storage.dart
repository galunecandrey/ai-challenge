import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_core/src/impl/providers/vis_db_provider.dart' show DBProvider;
import 'package:vitals_core/src/impl/storages/memory/secure_key_storage.dart' show SecureKeyStorage;
import 'package:vitals_utils/vitals_utils.dart'
    show AsyncLazy, BaseError, Either, OperationService, Unit, asyncLazy, right, unit;

abstract base class BoxStorage<T> implements Dao {
  final String? _initName;

  final String _name;

  late AsyncLazy<Box<T>> _box;

  late final Future<Box<T>> Function(String name) _openBox;

  final OperationService operationService;

  String? _boxId;

  @override
  String? get daoId => _boxId;

  String get tag => 'Box(id: $daoId, name: $_name${_initName != null ? ' initName: $_initName' : ''})';

  BoxStorage({
    required String name,
    required this.operationService,
    required DBProvider dbProvider,
    required SecureKeyStorage secureKeyStorage,
    required int version,
    bool isTest = false,
    String? secureKey,
    String? initName,
  })  : _name = name,
        _initName = initName {
    _openBox = (name) => dbProvider.openBox<T>(
          name: name,
          folder: _name,
          encryptionCipher: secureKey != null
              ? HiveAesCipher(
                  base64Decode(
                    secureKeyStorage.get(secureKey).getOrElse(() => ''),
                  ),
                )
              : null,
          version: version,
          bytes: isTest ? Uint8List(0) : null,
        );
    _box = asyncLazy<Box<T>>(
      () => _openBox(_initName ?? _name),
    );
  }

  Future<Box<T>> get box => _box.value;

  @override
  Future<Either<BaseError, Unit>> init([String? id]) {
    if (_boxId == id) {
      return Future.value(right(unit));
    }
    return operationService.safeUnitAsyncOp(
      () async {
        if (_box.isInitialized) {
          await close();
        }
        _boxId = id;
        _box = asyncLazy<Box<T>>(() => _openBox(daoId ?? _name));
      },
      tag: tag,
    );
  }

  @override
  Future<Either<BaseError, Unit>> clear() => operationService.safeUnitAsyncOp(
        () => box.then<int>(
          (value) => value.isOpen ? value.clear() : Future<int>.value(0),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @mustCallSuper
  @override
  Future<Either<BaseError, Unit>> close() {
    _boxId = null;
    if (!_box.isInitialized) {
      return Future.value(right(unit));
    }
    return operationService.safeUnitAsyncOp(
      () => box.then<void>((value) => value.isOpen ? value.close() : Future<void>.value()),
      tag: tag,
    );
  }

  bool _shouldTrackLog(dynamic e) => !(e is HiveError && e.message == 'Box has already been closed.');
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';

import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_core/src/impl/providers/vis_db_provider.dart' show DBProvider;
import 'package:vitals_core/src/impl/storages/memory/secure_key_storage.dart' show SecureKeyStorage;
import 'package:vitals_core/src/utils/const/realm.dart' show kSchemaVersion;
import 'package:vitals_core/src/utils/const/secure_keys.dart' show SecureKeys;
import 'package:vitals_utils/vitals_utils.dart'
    show AsyncLazy, BaseError, Either, OperationService, Unit, asyncLazy, right, unit;

abstract class RealmStorage<T extends RealmObject> implements Dao {
  final String? _initName;

  final String _name;

  late AsyncLazy<Realm> _realm;

  late final Future<Realm> Function(String? name) _openRealm;

  final OperationService operationService;

  String? _daoId;

  @override
  String? get daoId => _daoId;

  String get tag => 'RealmDatabase(id: $daoId, name: $_name${_initName != null ? ' initName: $_initName' : ''})';

  RealmStorage({
    required String name,
    required this.operationService,
    required DBProvider dbProvider,
    SecureKeyStorage? secureKeyStorage,
    bool isTest = false,
    bool isMemory = false,
    String? initName,
    Directory? dir,
    List<SchemaObject>? schemaObjects,
    int schemaVersion = kSchemaVersion,
  })  : _name = name,
        _initName = initName {
    _openRealm = (name) => dbProvider.openRealm(
          name: name,
          encryptionkey: secureKeyStorage != null
              ? base64Decode(
                  secureKeyStorage.get(SecureKeys.kRealm).getOrElse(() => ''),
                )
              : null,
          isMemory: isMemory,
          isTest: isTest,
          dir: dir,
          schemaObjects: schemaObjects,
          schemaVersion: schemaVersion,
        );
    _realm = asyncLazy<Realm>(
      () => _openRealm(_initName),
    );
  }

  Future<Realm> get box => _realm.value;

  @override
  Future<Either<BaseError, Unit>> init([String? id]) {
    if (daoId == id) {
      return Future.value(right(unit));
    }
    return operationService.safeUnitAsyncOp(
      () async {
        if (_realm.isInitialized) {
          await close();
        }
        _daoId = id;
        _realm = asyncLazy<Realm>(() => _openRealm(daoId));
      },
      tag: tag,
    );
  }

  @override
  Future<Either<BaseError, Unit>> clear() => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (v) => v.isClosed ? unit : v.write(() => v.deleteAll<T>()),
        ),
        tag: tag,
      );

  @mustCallSuper
  @override
  Future<Either<BaseError, Unit>> close() {
    _daoId = null;
    if (!_realm.isInitialized) {
      return Future.value(right(unit));
    }
    return operationService.safeUnitAsyncOp(
      () => box.then<void>((value) => value.isClosed ? unit : value.close()),
      tag: tag,
    );
  }
}

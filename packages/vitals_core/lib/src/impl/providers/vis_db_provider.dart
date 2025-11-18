import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:realm/realm.dart';
import 'package:vitals_core/src/utils/const/dao.dart' show DaoVersions;
import 'package:vitals_core/src/utils/const/realm.dart' show kRealmName, kSchemaVersion, kSchemasEntities;

@lazySingleton
class DBProvider {
  final HiveInterface _hive;
  late final String _path;

  DBProvider(
    this._hive,
  );

  void init(String path) {
    _path = join(
      join(path, 'fount'),
    );

    _hive.init(_path);
  }

  Future<Box<E>> openBox<E>({
    required String name,
    required String folder,
    required int version,
    HiveCipher? encryptionCipher,
    Uint8List? bytes,
  }) {
    var path = join(_path, folder);
    final parentDir = Directory(path);
    path = join(path, version.toString());
    final versionDir = Directory(path);
    if (!versionDir.existsSync()) {
      if (parentDir.existsSync()) {
        parentDir.deleteSync(recursive: true);
      }
      versionDir.createSync(recursive: true);
    }

    return _hive.openBox<E>(
      join(folder, version.toString(), name),
      encryptionCipher: encryptionCipher,
      bytes: bytes,
    );
  }

  Future<Realm> openRealm({
    required List<int>? encryptionkey,
    String? name,
    bool isTest = false,
    bool isMemory = false,
    Directory? dir,
    List<SchemaObject>? schemaObjects,
    int schemaVersion = kSchemaVersion,
  }) async {
    late String path;
    late Directory versionDir;
    if (dir == null) {
      path = join(_path, kRealmName);
      final parentDir = Directory(path);
      path = join(path, DaoVersions.kSecure.toString());
      versionDir = Directory(path);
      if (!versionDir.existsSync()) {
        if (parentDir.existsSync()) {
          parentDir.deleteSync(recursive: true);
        }
        versionDir.createSync(recursive: true);
      }
      path = join(path, name ?? 'global');
    } else {
      versionDir = dir;
      if (!versionDir.existsSync()) {
        versionDir.createSync(recursive: true);
      }
      path = join(dir.path, name ?? kRealmName);
    }
    final config = isMemory || isTest
        ? Configuration.inMemory(
            schemaObjects ?? kSchemasEntities,
            path: path,
          )
        : Configuration.local(
            schemaObjects ?? kSchemasEntities,
            path: path,
            //ignore: avoid_redundant_argument_values
            schemaVersion: schemaVersion,
            shouldDeleteIfMigrationNeeded: true,
            encryptionKey: encryptionkey,
          );

    try {
      return Realm(config);
    } catch (e) {
      if (e is RealmException && e.message.toLowerCase().contains('decryption failed')) {
        versionDir
          ..deleteSync(recursive: true)
          ..createSync(recursive: true);
        return Realm(config);
      } else {
        rethrow;
      }
    }
  }

  List<int> generateSecureKey(SecureKeyType type) {
    switch (type) {
      case SecureKeyType.primitive:
        return _hive.generateSecureKey();

      case SecureKeyType.advanced:
        final random = Random();
        return List<int>.generate(type.size, (i) => random.nextInt(256));
    }
  }

  void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!_hive.isAdapterRegistered(adapter.typeId)) {
      _hive.registerAdapter(adapter);
    }
  }
}

enum SecureKeyType {
  primitive(32),
  advanced(64);

  final int size;

  const SecureKeyType(this.size);
}

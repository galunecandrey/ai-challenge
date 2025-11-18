import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart' show DateTimeProvider;
import 'package:vitals_core/src/api/providers/device_id_provider.dart' show DeviceIdProvider;
import 'package:vitals_core/src/api/providers/platform_provider.dart' show PlatformProvider;
import 'package:vitals_core/src/impl/providers/vis_db_provider.dart' show DBProvider, SecureKeyType;
import 'package:vitals_core/src/impl/storages/memory/secure_key_storage.dart' show SecureKeyStorage;
import 'package:vitals_core/src/model/ai_session/ai_session.dart';
import 'package:vitals_core/src/utils/const/dao.dart' show DaoClasses, DaoVersions;
import 'package:vitals_core/src/utils/const/secure_keys.dart' show SecureKeys;

class InitFramework {
  static final InitFramework _singleton = InitFramework._();

  // Ensures end-users cannot initialize the class.
  InitFramework._();

  static Future<InitFramework> init(
    Directory directory,
    PlatformProvider platformProvider,
    DateTimeProvider dateTimeProvider,
    DBProvider dbProvider,
    SecureKeyStorage secureKeyStorage,
    String secureKey,
    DeviceIdProvider deviceIdProvider,
  ) async {
    await Future.wait([
      _initHive(
        platformProvider,
        dateTimeProvider,
        directory,
        dbProvider,
        secureKeyStorage,
        secureKey,
        deviceIdProvider,
      ).then(
        (v) => Future.wait([
          platformProvider.fetchPackageInfo(),
          platformProvider.fetchDeviceInfo(),
        ]),
      ),
      platformProvider.fetchSystemTimeFormat().then(
            (value) => value.leftMap(
              (l) => throw Exception(l.message),
            ),
          ),
      if (platformProvider.platformInfo.isAndroid || platformProvider.platformInfo.isIOS)
        platformProvider.fetchHasEarpiece().then(
              (value) => value.leftMap(
                (l) => throw Exception(l.message),
              ),
            ),
    ]);
    return _singleton;
  }

  static Future<void> _initHive(
    PlatformProvider platformProvider,
    DateTimeProvider dateTimeProvider,
    Directory dir,
    DBProvider dbProvider,
    SecureKeyStorage keyStorage,
    String secureKey,
    DeviceIdProvider deviceIdProvider,
  ) {
    dbProvider.init(dir.path);

    _registerAdapter(dbProvider, AISessionAdapter());

    return _initSecureKeys(
      platformProvider,
      dateTimeProvider,
      dbProvider,
      keyStorage,
      secureKey,
      deviceIdProvider,
    );
  }

  static void _registerAdapter<T>(DBProvider dbProvider, TypeAdapter<T> adapter) {
    dbProvider.registerAdapter(adapter);
  }

  static Future<void> _initSecureKeys(
    PlatformProvider platformProvider,
    DateTimeProvider dateTimeProvider,
    DBProvider dbProvider,
    SecureKeyStorage keyStorage,
    String secureKey,
    DeviceIdProvider deviceIdProvider,
  ) async {
    final box = await dbProvider.openBox<String>(
      name: DaoClasses.kSecure,
      folder: DaoClasses.kSecure,
      version: DaoVersions.kSecure,
      encryptionCipher: HiveAesCipher(
        base64Decode(secureKey),
      ),
      bytes: platformProvider.platformInfo.isTest ? Uint8List(0) : null,
    );

    await _checkSecureKey(
      dbProvider,
      box,
      keyStorage,
      SecureKeys.kDeviceId,
      secureKeyGenerator: () => deviceIdProvider.deviceId,
    );
    await _checkSecureKey(dbProvider, box, keyStorage, SecureKeys.kRealm, secureKeyType: SecureKeyType.advanced);
    await _checkSecureKey(dbProvider, box, keyStorage, SecureKeys.kSessions);
    await box.close();
  }

  static Future<void> _checkSecureKey(
    DBProvider dbProvider,
    Box<String> box,
    SecureKeyStorage keyStorage,
    String key, {
    SecureKeyType secureKeyType = SecureKeyType.primitive,
    Future<String> Function()? secureKeyGenerator,
  }) async {
    if (!box.containsKey(key)) {
      final newKey = await secureKeyGenerator?.call() ?? base64UrlEncode(dbProvider.generateSecureKey(secureKeyType));
      await box.put(key, newKey);
    }

    keyStorage.set(key, box.get(key)!);
  }
}

import 'dart:async' show FutureOr;
import 'dart:io' show Directory;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:hive/hive.dart' show Hive, HiveInterface;
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:ksuid/ksuid.dart' show KSUID;
import 'package:logger/logger.dart';
import 'package:open_dir/open_dir.dart' show OpenDir;
import 'package:openai_dart/openai_dart.dart';

//ignore:depend_on_referenced_packages
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart' show DateTimeProvider;
import 'package:vitals_core/src/api/providers/device_id_provider.dart' show DeviceIdProvider;
import 'package:vitals_core/src/api/providers/platform_provider.dart' show PlatformProvider;
import 'package:vitals_core/src/api/storage/database/database.dart';
import 'package:vitals_core/src/impl/providers/vis_db_provider.dart' show DBProvider;
import 'package:vitals_core/src/impl/storages/memory/secure_key_storage.dart' show SecureKeyStorage;
import 'package:vitals_core/src/init_framework.dart' show InitFramework;
import 'package:vitals_utils/vitals_utils.dart' as utils show OperationService;

@module
abstract class CoreModules {
  @lazySingleton
  OpenDir get openDir => OpenDir();

  @lazySingleton
  LogPrinter get logPrinter => PrettyPrinter(
        dateTimeFormat: DateTimeFormat.dateAndTime,
        colors: false,
      );

  @lazySingleton
  Logger logger(
    LogFilter logFilter,
    LogPrinter logPrinter,
    LogOutput logOutput,
  ) =>
      Logger(
        filter: logFilter,
        printer: logPrinter,
        output: logOutput,
      );

  @lazySingleton
  PackageInfoPlatform get packageInfoPlatform => PackageInfoPlatform.instance;

  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @lazySingleton
  OpenAIClient openAIClient({
    required http.BaseClient client,
    @Named('AIKey') required String key,
  }) =>
      OpenAIClient(apiKey: key, client: client);

  @LazySingleton(dispose: disposeHive)
  HiveInterface get hive => Hive;

  @lazySingleton
  @Named('huggingfaceAIClient')
  OpenAIClient huggingfaceAIClient({@Named('huggingfaceAIKey') required String key}) => OpenAIClient(
        baseUrl: 'https://router.huggingface.co/v1',
        apiKey: key,
      );

  @injectable
  KSUID getKSUID(DateTimeProvider provider) => KSUID.generate(date: provider.current);

  @lazySingleton
  Future<InitFramework> initFramework(
    Directory directory,
    PlatformProvider platformProvider,
    DateTimeProvider dateTimeProvider,
    DBProvider dbProvider,
    SecureKeyStorage secureKeyStorage,
    DeviceIdProvider deviceIdProvider,
    GetIt di,
    @Named('secureKey') String secureKey,
  ) =>
      InitFramework.init(
        directory,
        platformProvider,
        dateTimeProvider,
        dbProvider,
        secureKeyStorage,
        secureKey,
        deviceIdProvider,
      ).then((v) {
        try {
          di<Database>().init('global');
        } catch (e) {
          di<utils.OperationService>().logError('NotificationModule init error: $e');
        }
        return v;
      });
}

FutureOr<dynamic> disposeHive(HiveInterface hive) => hive.close();

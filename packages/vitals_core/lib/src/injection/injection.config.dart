// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i497;
import 'dart:ui' as _i264;

import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ksuid/ksuid.dart' as _i488;
import 'package:logger/logger.dart' as _i974;
import 'package:open_dir/open_dir.dart' as _i664;
import 'package:openai_dart/openai_dart.dart' as _i948;
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart'
    as _i490;
import 'package:vitals_core/src/api/handlers/error_handler.dart' as _i676;
import 'package:vitals_core/src/api/providers/ai_agent_provider.dart' as _i970;
import 'package:vitals_core/src/api/providers/date_time_provider.dart' as _i804;
import 'package:vitals_core/src/api/providers/device_id_provider.dart' as _i687;
import 'package:vitals_core/src/api/providers/lifecycle_events_provider.dart'
    as _i182;
import 'package:vitals_core/src/api/providers/platform_provider.dart' as _i997;
import 'package:vitals_core/src/api/service/launch_service.dart' as _i193;
import 'package:vitals_core/src/api/storage/database/dao/ai_session_dao.dart'
    as _i133;
import 'package:vitals_core/src/api/storage/database/dao/embedding_dao.dart'
    as _i739;
import 'package:vitals_core/src/api/storage/database/dao/messages_dao.dart'
    as _i613;
import 'package:vitals_core/src/api/storage/database/database.dart' as _i109;
import 'package:vitals_core/src/impl/log/log.dart' as _i514;
import 'package:vitals_core/src/impl/operation/operation_service_impl.dart'
    as _i579;
import 'package:vitals_core/src/impl/providers/ai_agent_provider_impl.dart'
    as _i90;
import 'package:vitals_core/src/impl/providers/date_time_provider_impl.dart'
    as _i587;
import 'package:vitals_core/src/impl/providers/device_id_provider_impl.dart'
    as _i747;
import 'package:vitals_core/src/impl/providers/lifecycle_events_provider_impl.dart'
    as _i163;
import 'package:vitals_core/src/impl/providers/platform_provider_impl.dart'
    as _i291;
import 'package:vitals_core/src/impl/providers/vis_db_provider.dart' as _i135;
import 'package:vitals_core/src/impl/service/launch_service_impl.dart'
    as _i1001;
import 'package:vitals_core/src/impl/storages/ai_agent_storage.dart' as _i532;
import 'package:vitals_core/src/impl/storages/database/dao/ai_session_dao_impl.dart'
    as _i240;
import 'package:vitals_core/src/impl/storages/database/dao/embedding_dao_impl.dart'
    as _i57;
import 'package:vitals_core/src/impl/storages/database/dao/messages_dao_impl.dart'
    as _i513;
import 'package:vitals_core/src/impl/storages/database/database_impl.dart'
    as _i281;
import 'package:vitals_core/src/impl/storages/memory/secure_key_storage.dart'
    as _i83;
import 'package:vitals_core/src/impl/storages/messages_storage.dart' as _i678;
import 'package:vitals_core/src/init_framework.dart' as _i738;
import 'package:vitals_core/src/injection/core_modules.dart' as _i900;
import 'package:vitals_core/src/injection/defines.dart' as _i821;
import 'package:vitals_core/src/network/logging_client.dart' as _i822;
import 'package:vitals_utils/vitals_utils.dart' as _i865;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final coreModules = _$CoreModules();
    final defines = _$Defines();
    gh.lazySingleton<_i664.OpenDir>(() => coreModules.openDir);
    gh.lazySingleton<_i974.LogPrinter>(() => coreModules.logPrinter);
    gh.lazySingleton<_i490.PackageInfoPlatform>(
        () => coreModules.packageInfoPlatform);
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
        () => coreModules.deviceInfoPlugin);
    gh.lazySingleton<_i979.HiveInterface>(
      () => coreModules.hive,
      dispose: _i900.disposeHive,
    );
    gh.lazySingleton<_i865.PlatformInfo>(() => defines.platformInfo);
    gh.lazySingleton<_i974.LogFilter>(() => _i514.VitalsLogFilter());
    gh.lazySingleton<String>(
      () => defines.gitHubAIKey,
      instanceName: 'GitHubAIKey',
    );
    gh.lazySingleton<String>(
      () => defines.openAIKey,
      instanceName: 'AIKey',
    );
    gh.lazySingleton<String>(
      () => defines.secureKey,
      instanceName: 'secureKey',
    );
    gh.lazySingleton<_i519.BaseClient>(() => _i822.LoggingClient());
    gh.lazySingleton<_i182.LifecycleEventsProvider>(
      () => _i163.DefaultLifecycleEventsProviderImpl(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<String>(
      () => defines.huggingfaceAIKey,
      instanceName: 'huggingfaceAIKey',
    );
    gh.lazySingleton<_i264.Size>(
      () => defines.minDesktopWindowSize,
      instanceName: 'minDesktopWindowSize',
    );
    gh.lazySingleton<_i948.OpenAIClient>(
      () => coreModules.huggingfaceAIClient(
          key: gh<String>(instanceName: 'huggingfaceAIKey')),
      instanceName: 'huggingfaceAIClient',
    );
    gh.lazySingleton<_i135.DBProvider>(
        () => _i135.DBProvider(gh<_i979.HiveInterface>()));
    gh.lazySingleton<_i948.OpenAIClient>(() => coreModules.openAIClient(
          client: gh<_i519.BaseClient>(),
          key: gh<String>(instanceName: 'AIKey'),
        ));
    gh.lazySingleton<_i804.DateTimeProvider>(
        () => _i587.DateTimeProviderImpl(gh<_i182.LifecycleEventsProvider>()));
    gh.factory<_i488.KSUID>(
        () => coreModules.getKSUID(gh<_i804.DateTimeProvider>()));
    gh.lazySingleton<_i974.LogOutput>(() => _i514.VitalsLogOutput(
          gh<_i497.Directory>(),
          gh<_i804.DateTimeProvider>(),
        ));
    gh.lazySingleton<_i974.Logger>(() => coreModules.logger(
          gh<_i974.LogFilter>(),
          gh<_i974.LogPrinter>(),
          gh<_i974.LogOutput>(),
        ));
    gh.lazySingleton<_i676.ErrorHandler>(() => _i676.ErrorHandler(
          gh<_i974.Logger>(),
          gh<_i865.PlatformInfo>(),
        ));
    gh.lazySingleton<_i865.OperationService>(
        () => _i579.OperationServiceImpl(gh<_i676.ErrorHandler>()));
    gh.lazySingleton<_i193.LaunchService>(() => _i1001.LaunchServiceImpl(
          gh<_i865.OperationService>(),
          gh<_i664.OpenDir>(),
        ));
    gh.lazySingleton<_i997.PlatformProvider>(
      () => _i291.PlatformProviderImpl(
        gh<_i865.OperationService>(),
        gh<_i490.PackageInfoPlatform>(),
        gh<_i833.DeviceInfoPlugin>(),
        gh<_i865.PlatformInfo>(),
        gh<_i264.Size>(instanceName: 'minDesktopWindowSize'),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i532.AIAgentStorage>(
      () => _i532.AIAgentStorage(gh<_i865.OperationService>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i83.SecureKeyStorage>(
      () => _i83.SecureKeyStorage(gh<_i865.OperationService>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i678.MessagesStorage>(
      () => _i678.MessagesStorage(gh<_i865.OperationService>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i687.DeviceIdProvider>(() => _i747.DeviceIdProviderImpl(
          gh<_i865.OperationService>(),
          gh<_i997.PlatformProvider>(),
          gh<_i488.KSUID>(),
        ));
    gh.lazySingleton<bool>(
      () => defines.isTestMode(gh<_i997.PlatformProvider>()),
      instanceName: 'isTestMode',
    );
    gh.lazySingleton<_i133.AISessionDao>(() => _i240.AISessionDaoImpl(
          dbProvider: gh<_i135.DBProvider>(),
          secureKeyStorage: gh<_i83.SecureKeyStorage>(),
          operationService: gh<_i865.OperationService>(),
          isTest: gh<bool>(instanceName: 'isTestMode'),
        ));
    gh.lazySingleton<bool>(
      () => defines.shouldLog(isTestMode: gh<bool>(instanceName: 'isTestMode')),
      instanceName: 'shouldLog',
    );
    gh.lazySingletonAsync<_i738.InitFramework>(() => coreModules.initFramework(
          gh<_i497.Directory>(),
          gh<_i997.PlatformProvider>(),
          gh<_i804.DateTimeProvider>(),
          gh<_i135.DBProvider>(),
          gh<_i83.SecureKeyStorage>(),
          gh<_i687.DeviceIdProvider>(),
          gh<_i174.GetIt>(),
          gh<String>(instanceName: 'secureKey'),
        ));
    gh.lazySingleton<_i613.MessagesDao>(() => _i513.MessagesDaoImpl(
          dbProvider: gh<_i135.DBProvider>(),
          secureKeyStorage: gh<_i83.SecureKeyStorage>(),
          operationService: gh<_i865.OperationService>(),
          isTest: gh<bool>(instanceName: 'isTestMode'),
        ));
    gh.lazySingleton<_i739.EmbeddingDao>(() => _i57.EmbeddingDaoImpl(
          dbProvider: gh<_i135.DBProvider>(),
          secureKeyStorage: gh<_i83.SecureKeyStorage>(),
          operationService: gh<_i865.OperationService>(),
          isTest: gh<bool>(instanceName: 'isTestMode'),
        ));
    gh.lazySingleton<_i109.Database>(
      () => _i281.DatabaseImpl(
        gh<_i865.OperationService>(),
        gh<_i613.MessagesDao>(),
        gh<_i133.AISessionDao>(),
        gh<_i739.EmbeddingDao>(),
      ),
      dispose: _i281.closeDatabase,
    );
    gh.lazySingleton<_i970.AIAgentProvider>(() => _i90.AIRepositoryImpl(
          gh<_i948.OpenAIClient>(),
          gh<_i948.OpenAIClient>(instanceName: 'huggingfaceAIClient'),
          gh<_i865.OperationService>(),
          gh<_i804.DateTimeProvider>(),
          gh<_i109.Database>(),
          gh<String>(instanceName: 'GitHubAIKey'),
        ));
    return this;
  }
}

class _$CoreModules extends _i900.CoreModules {}

class _$Defines extends _i821.Defines {}

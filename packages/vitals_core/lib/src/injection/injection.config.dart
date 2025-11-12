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
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:openai_dart/openai_dart.dart' as _i948;
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart'
    as _i490;
import 'package:vitals_core/src/api/handlers/error_handler.dart' as _i676;
import 'package:vitals_core/src/api/providers/ai_agent_provider.dart' as _i970;
import 'package:vitals_core/src/api/providers/date_time_provider.dart' as _i804;
import 'package:vitals_core/src/api/providers/lifecycle_events_provider.dart'
    as _i182;
import 'package:vitals_core/src/api/providers/platform_provider.dart' as _i997;
import 'package:vitals_core/src/impl/log/log.dart' as _i514;
import 'package:vitals_core/src/impl/operation/operation_service_impl.dart'
    as _i579;
import 'package:vitals_core/src/impl/providers/ai_agent_provider_impl.dart'
    as _i90;
import 'package:vitals_core/src/impl/providers/date_time_provider_impl.dart'
    as _i587;
import 'package:vitals_core/src/impl/providers/lifecycle_events_provider_impl.dart'
    as _i163;
import 'package:vitals_core/src/impl/providers/platform_provider_impl.dart'
    as _i291;
import 'package:vitals_core/src/impl/storages/ai_agent_storage.dart' as _i532;
import 'package:vitals_core/src/impl/storages/messages_storage.dart' as _i678;
import 'package:vitals_core/src/injection/core_modules.dart' as _i900;
import 'package:vitals_core/src/injection/defines.dart' as _i821;
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
    gh.lazySingleton<_i974.LogPrinter>(() => coreModules.logPrinter);
    gh.lazySingleton<_i490.PackageInfoPlatform>(
        () => coreModules.packageInfoPlatform);
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
        () => coreModules.deviceInfoPlugin);
    gh.lazySingleton<_i865.PlatformInfo>(() => defines.platformInfo);
    gh.lazySingleton<_i974.LogFilter>(() => _i514.VitalsLogFilter());
    gh.lazySingleton<String>(
      () => defines.openAIKey,
      instanceName: 'AIKey',
    );
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
    gh.lazySingleton<_i948.OpenAIClient>(
        () => coreModules.openAIClient(key: gh<String>(instanceName: 'AIKey')));
    gh.lazySingleton<_i804.DateTimeProvider>(
        () => _i587.DateTimeProviderImpl(gh<_i182.LifecycleEventsProvider>()));
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
    gh.lazySingleton<_i678.MessagesStorage>(
      () => _i678.MessagesStorage(gh<_i865.OperationService>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i532.AIAgentStorage>(
      () => _i532.AIAgentStorage(gh<_i865.OperationService>()),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i970.AIAgentProvider>(() => _i90.AIRepositoryImpl(
          gh<_i948.OpenAIClient>(),
          gh<_i948.OpenAIClient>(instanceName: 'huggingfaceAIClient'),
          gh<_i865.OperationService>(),
          gh<_i804.DateTimeProvider>(),
        ));
    gh.lazySingleton<bool>(
      () => defines.isTestMode(gh<_i997.PlatformProvider>()),
      instanceName: 'isTestMode',
    );
    gh.lazySingleton<bool>(
      () => defines.shouldLog(isTestMode: gh<bool>(instanceName: 'isTestMode')),
      instanceName: 'shouldLog',
    );
    return this;
  }
}

class _$CoreModules extends _i900.CoreModules {}

class _$Defines extends _i821.Defines {}

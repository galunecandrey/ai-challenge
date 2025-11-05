// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:i18next/i18next.dart' as _i391;
import 'package:injectable/injectable.dart' as _i526;
import 'package:vitals_arch/vitals_arch.dart' as _i878;
import 'package:vitals_core/vitals_core.dart' as _i479;
import 'package:vitals_sdk_example/common/injection/di_module.dart' as _i573;
import 'package:vitals_sdk_example/common/localization/localization_data_source.dart'
    as _i775;
import 'package:vitals_sdk_example/common/localization/translation_provider.dart'
    as _i661;
import 'package:vitals_sdk_example/common/utils/vitals_system_tray_manager.dart'
    as _i870;
import 'package:vitals_sdk_example/features/home/vm/messages_room_viewmodel.dart'
    as _i512;
import 'package:vitals_sdk_example/features/init/initializer.dart' as _i85;
import 'package:vitals_sdk_example/router/router.dart' as _i126;
import 'package:vitals_sdk_example/router/vitals_router.dart' as _i828;
import 'package:vitals_sdk_example/router/vitals_router_module.dart' as _i623;
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
    final dIModule = _$DIModule();
    final visRouterModule = _$VisRouterModule();
    gh.lazySingleton<_i878.GetIt>(() => dIModule.di);
    gh.lazySingleton<_i828.VitalsRouter>(() => visRouterModule.router);
    gh.lazySingleton<_i870.VitalsSystemTrayManager>(
        () => _i870.VitalsSystemTrayManager(gh<_i479.PlatformProvider>()));
    gh.lazySingleton<_i391.LocalizationDataSource>(
        () => _i775.VisLocalizationDataSource());
    gh.factory<_i512.MessagesRoomViewModel>(
        () => _i512.MessagesRoomViewModel(gh<_i479.AIRepository>()));
    gh.lazySingleton<_i85.Initializer>(() => _i85.Initializer(
          gh<_i878.GetIt>(),
          gh<_i865.OperationService>(),
        ));
    gh.lazySingleton<_i661.TranslationProvider>(
        () => _i661.TranslationProvider(gh<_i126.VitalsRouter>()));
    return this;
  }
}

class _$DIModule extends _i573.DIModule {}

class _$VisRouterModule extends _i623.VisRouterModule {}

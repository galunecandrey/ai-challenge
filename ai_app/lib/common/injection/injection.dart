import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart' as core;
import 'package:vitals_sdk_example/common/injection/injection.config.dart';

@injectableInit
void configureInjection({String? environment}) {
  core.configureInjection(getIt, environment: environment);
  getIt.init(environment: environment);
}

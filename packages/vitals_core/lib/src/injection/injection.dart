import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/injection/injection.config.dart';

@injectableInit
void configureInjection(GetIt getIt, {String? environment}) => getIt.init(environment: environment);

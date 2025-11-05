import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart';

@module
abstract class DIModule {
  @lazySingleton
  GetIt get di => getIt;
}

import 'package:injectable/injectable.dart';
import 'package:vitals_sdk_example/router/vitals_router.dart';

@module
abstract class VisRouterModule {
  @lazySingleton
  VitalsRouter get router => VitalsRouter();
}

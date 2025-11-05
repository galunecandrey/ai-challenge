import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/app.dart';
import 'package:vitals_sdk_example/common/injection/injection.dart' as injection;
import 'package:vitals_sdk_example/common/utils/const/global_error.dart';
import 'package:vitals_sdk_example/features/init/initializer.dart';
import 'package:vitals_utils/vitals_utils.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injection.configureInjection();
  final isDesktop = getIt<PlatformInfo>().isDesktop;

  if (isDesktop) {
    await windowManager.ensureInitialized();
  }
  getIt.registerSingleton<Directory>(
    isDesktop ? await getApplicationSupportDirectory() : await getApplicationDocumentsDirectory(),
  );

  setupErrorsHandling();

  runApplication();
}

void runApplication() {
  getIt<Initializer>();
  runApp(
    const VitalsSDKExampleApp(),
  );
}

void setupErrorsHandling() {
  FlutterError.onError = _reportError;
  Isolate.current.addErrorListener(
    RawReceivePort((dynamic pair) async {
      try {
        final errorAndStacktrace = pair as List<dynamic>;
        await _recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last as StackTrace,
          GlobalErrors.kCurrentIsolateError,
        );
      } catch (error, stack) {
        await _recordError(
          error,
          stack,
          GlobalErrors.kCurrentIsolateError,
        );
      }
    }).sendPort,
  );
  PlatformDispatcher.instance.onError = (error, stack) {
    _recordError(
      error,
      stack,
      GlobalErrors.kPlatformDispatcher,
    );
    return true;
  };
}

Future<void> _reportError(FlutterErrorDetails exception) async => _onError(
      exception.exceptionAsString(),
      exception.exception,
      exception.stack,
      GlobalErrors.kFlutterError,
    );

Future<void> _recordError(
  dynamic exception,
  StackTrace stack,
  String tag,
) async =>
    _onError(
      exception.toString(),
      exception,
      stack,
      tag,
    );

void _onError(
  String message,
  dynamic error,
  StackTrace? stack,
  String tag,
) =>
    getIt<ErrorHandler>().onError(
      error,
      stack,
      tag: tag,
    );

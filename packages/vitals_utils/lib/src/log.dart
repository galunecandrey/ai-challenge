import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:vitals_utils/src/platform/test_io.dart' as io;
import 'package:vitals_utils/src/platform/test_web.dart' as web;

enum VISLogLevel {
  verbose('V'),
  debug('D'),
  info('I'),
  warning('W'),
  error('E'),
  wtf('WTF'),
  off('');

  final String tag;

  const VISLogLevel(this.tag);
}

VISLogLevel logLevel = VISLogLevel.verbose;

final kShouldLog = kDebugMode && !(kIsWeb ? web.isTest : io.isTest);

final _logger = Logger(
  filter: _VisLogFilter(
    needLog: kShouldLog,
  ),
  printer: PrettyPrinter(
    dateTimeFormat: DateTimeFormat.dateAndTime,
  ),
);

class _VisLogFilter extends LogFilter {
  _VisLogFilter({required this.needLog});

  final bool needLog;

  @override
  bool shouldLog(LogEvent event) => needLog;
}

void error(
  dynamic message, {
  bool useLogger = true,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    _log(
      message,
      tag: tag,
      level: VISLogLevel.error,
      useLogger: useLogger,
      error: error,
      stackTrace: stackTrace,
    );

void debug(
  dynamic message, {
  bool useLogger = true,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    _log(
      message,
      tag: tag,
      level: VISLogLevel.debug,
      useLogger: useLogger,
      error: error,
      stackTrace: stackTrace,
    );

void verbose(
  dynamic message, {
  bool useLogger = true,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    _log(
      message,
      tag: tag,
      level: VISLogLevel.verbose,
      useLogger: useLogger,
      error: error,
      stackTrace: stackTrace,
    );

void info(
  dynamic message, {
  bool useLogger = true,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    _log(
      message,
      tag: tag,
      level: VISLogLevel.info,
      useLogger: useLogger,
      error: error,
      stackTrace: stackTrace,
    );

void warning(
  dynamic message, {
  bool useLogger = true,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    _log(
      message,
      tag: tag,
      level: VISLogLevel.warning,
      useLogger: useLogger,
      error: error,
      stackTrace: stackTrace,
    );

void wtf(
  dynamic message, {
  bool useLogger = true,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    _log(
      message,
      tag: tag,
      level: VISLogLevel.wtf,
      useLogger: useLogger,
      error: error,
      stackTrace: stackTrace,
    );

void _log(
  dynamic message, {
  required VISLogLevel level,
  bool useLogger = false,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
}) {
  if (kShouldLog && (logLevel.index <= level.index)) {
    if (useLogger) {
      switch (level) {
        case VISLogLevel.verbose:
          _logger.t(
            message,
            error: error,
            stackTrace: stackTrace,
          );
          break;
        case VISLogLevel.debug:
          _logger.d(
            message,
            error: error,
            stackTrace: stackTrace,
          );
          break;
        case VISLogLevel.info:
          _logger.i(
            message,
            error: error,
            stackTrace: stackTrace,
          );
          break;
        case VISLogLevel.warning:
          _logger.w(
            message,
            error: error,
            stackTrace: stackTrace,
          );
          break;
        case VISLogLevel.error:
          _logger.e(
            message,
            error: error,
            stackTrace: stackTrace,
          );
          break;
        case VISLogLevel.wtf:
          _logger.f(
            message,
            error: error,
            stackTrace: stackTrace,
          );
          break;
        case VISLogLevel.off:
          break;
      }
    } else {
      log(
        message.toString(),
        name: tag ?? level.name,
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

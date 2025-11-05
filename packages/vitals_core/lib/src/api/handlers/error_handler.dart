//ignore_for_file: deprecated_member_use
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:vitals_utils/vitals_utils.dart' as utils;
import 'package:vitals_utils/vitals_utils.dart';

typedef SaveFunc = void Function(dynamic message, {dynamic error, StackTrace? stackTrace});
typedef LogFunc = void Function(
  dynamic message, {
  bool useLogger,
  String? tag,
  dynamic error,
  StackTrace? stackTrace,
});

@lazySingleton
class ErrorHandler {
  final Logger _logger;
  final utils.PlatformInfo _platformInfo;

  ErrorHandler(this._logger, this._platformInfo);

  void onError(
    dynamic error,
    StackTrace? stack, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  }) {
    _logError(
      error,
      tag: tag,
      stack: stack,
      shouldLog: shouldLog,
      messageBuilder: (msg) => 'ErrorHandler:\n$msg',
    );
    _trackError(
      error,
      tag: tag,
      stack: stack,
      shouldTrackLog: shouldTrackLog,
      trackLogWhen: trackLogWhen,
      shouldLog: shouldLog,
    );
    _saveError(
      error,
      tag: tag,
      stack: stack,
      shouldSaveLog: shouldSaveLog,
      saveLogWhen: saveLogWhen,
      shouldLog: shouldLog,
    );
  }

  void _logError(
    dynamic error, {
    String Function(String msg)? messageBuilder,
    StackTrace? stack,
    String? tag,
    bool shouldLog = true,
  }) {
    if (shouldLog) {
      final dynamic log = tag != null ? ErrorWithTag(tag: tag, error: error) : error;
      if (error is DioException) {
        utils.error(
          messageBuilder?.call(log.toString()) ?? log.toString(),
          error: log,
          stackTrace: stack ?? error.stackTrace,
        );
      } else {
        utils.error(
          messageBuilder?.call(log.toString()) ?? log.toString(),
          error: log,
          stackTrace: stack,
        );
      }
    }
  }

  void _saveError(
    dynamic error, {
    StackTrace? stack,
    String? tag,
    bool shouldLog = true,
    bool? shouldSaveLog,
    bool Function(dynamic error)? saveLogWhen,
  }) {
    if (saveLogWhen?.call(error) ?? shouldSaveLog ?? shouldLog) {
      final dynamic log = tag != null ? ErrorWithTag(tag: tag, error: error) : error;
      _logger.e(
        log.toString(),
        error: log,
        stackTrace: stack,
      );
    }
  }

  Future<void> _trackError(
    dynamic error, {
    StackTrace? stack,
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool Function(dynamic error)? trackLogWhen,
  }) async {
    if (_platformInfo.isProduction && (trackLogWhen?.call(error) ?? shouldTrackLog ?? shouldLog)) {
      try {} catch (e, s) {
        final log = ErrorWithTag(tag: 'AnalyticsService.trackError', error: e);
        utils.error(
          log.toString(),
          error: log,
          stackTrace: s,
        );
        _logger.e(
          log.toString(),
          error: log,
          stackTrace: s,
        );
      }
    }
  }

  void logEvent(
    Level level,
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stack,
    String? tag,
    bool? shouldSaveLog,
  }) {
    _logEvent(
      level,
      message,
      shouldLog: shouldLog,
      error: error,
      stack: stack,
      tag: tag,
    );
    _trackEvent(
      level,
      message,
      shouldTrackLog: shouldTrackLog,
      error: error,
      stack: stack,
      tag: tag,
    );
    _saveEvent(
      level,
      message,
      shouldLog: shouldLog,
      shouldSaveLog: shouldSaveLog,
      error: error,
      stack: stack,
      tag: tag,
    );
  }

  void _logEvent(
    Level level,
    String message, {
    dynamic error,
    StackTrace? stack,
    String? tag,
    bool shouldLog = true,
  }) {
    if (shouldLog) {
      final dynamic log = tag != null ? ErrorWithTag(tag: tag, error: message) : message;
      if (error is DioException) {
        _logFunc(level)?.call(
          log.toString(),
          error: error,
          stackTrace: stack ?? error.stackTrace,
        );
      } else {
        _logFunc(level)?.call(
          log.toString(),
          error: error,
          stackTrace: stack,
        );
      }
    }
  }

  void _saveEvent(
    Level level,
    String message, {
    dynamic error,
    StackTrace? stack,
    String? tag,
    bool shouldLog = true,
    bool? shouldSaveLog,
  }) {
    if (shouldSaveLog ?? shouldLog) {
      final dynamic log = tag != null ? ErrorWithTag(tag: tag, error: message) : message;
      _saveFunc(level)?.call(log.toString(), error: error, stackTrace: stack);
    }
  }

  Future<void> _trackEvent(
    Level level,
    String message, {
    dynamic error,
    StackTrace? stack,
    String? tag,
    bool shouldTrackLog = false,
  }) async {
    if (_platformInfo.isProduction && level == Level.error && shouldTrackLog) {
      try {} catch (e, s) {
        final log = ErrorWithTag(tag: 'AnalyticsService.trackError', error: e);
        utils.error(
          log.toString(),
          error: log,
          stackTrace: s,
        );
        _logger.e(
          log.toString(),
          error: log,
          stackTrace: s,
        );
      }
    }
  }

  SaveFunc? _saveFunc(Level level) => switch (level) {
        Level.verbose || Level.trace => _logger.v,
        Level.debug || Level.all => _logger.d,
        Level.info => _logger.i,
        Level.warning => _logger.w,
        Level.error => _logger.e,
        Level.wtf || Level.fatal => _logger.wtf,
        Level.nothing || Level.off => null,
      };

  LogFunc? _logFunc(Level level) => switch (level) {
        Level.verbose || Level.trace => utils.verbose,
        Level.debug || Level.all => utils.debug,
        Level.info => utils.info,
        Level.warning => utils.warning,
        Level.error => utils.error,
        Level.wtf || Level.fatal => utils.wtf,
        Level.nothing || Level.off => null,
      };
}

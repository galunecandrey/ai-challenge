import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:vitals_core/src/api/handlers/error_handler.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: OperationService)
class OperationServiceImpl implements OperationService {
  OperationServiceImpl(this._errorHandler);

  final ErrorHandler _errorHandler;

  @override
  Future<Either<BaseError, T>> safeAsyncOp<T>(
    Future<T> Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  }) async {
    try {
      final response = await operation();
      return right(response);
    } on DioException catch (error, stack) {
      _errorHandler.onError(
        error,
        stack,
        tag: tag,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog ?? false,
        shouldSaveLog: shouldSaveLog,
        trackLogWhen: trackLogWhen,
        saveLogWhen: saveLogWhen,
      );
      return left(
        BaseError(
          statusCode: error.response?.statusCode,
          message: error.response?.statusMessage,
          data: error.response?.data,
          error: error.error ?? error,
        ),
      );
    } catch (error, stack) {
      _errorHandler.onError(
        error,
        stack,
        tag: tag,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        shouldSaveLog: shouldSaveLog,
        trackLogWhen: trackLogWhen,
        saveLogWhen: saveLogWhen,
      );
      return left(
        BaseError(message: error.toString(), error: error),
      );
    }
  }

  @override
  Future<Either<BaseError, Unit>> safeUnitAsyncOp(
    Future<dynamic> Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  }) =>
      safeAsyncOp<dynamic>(
        operation,
        tag: tag,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        shouldSaveLog: shouldSaveLog,
        trackLogWhen: trackLogWhen,
        saveLogWhen: saveLogWhen,
      ).then((r) => r.map((dynamic _) => unit));

  @override
  Either<BaseError, T> safeSyncOp<T>(
    T Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  }) {
    try {
      final response = operation();
      return right(response);
    } catch (error, stack) {
      _errorHandler.onError(
        error,
        stack,
        tag: tag,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        shouldSaveLog: shouldSaveLog,
        trackLogWhen: trackLogWhen,
        saveLogWhen: saveLogWhen,
      );
      return left(BaseError(message: error.toString(), error: error));
    }
  }

  @override
  Either<BaseError, Unit> safeUnitSyncOp(
    dynamic Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  }) =>
      safeSyncOp<dynamic>(
        operation,
        tag: tag,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        shouldSaveLog: shouldSaveLog,
        trackLogWhen: trackLogWhen,
        saveLogWhen: saveLogWhen,
      ).map((dynamic _) => unit);

  @override
  void logDebug(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  }) =>
      _errorHandler.logEvent(
        Level.debug,
        message,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        error: error,
        stack: stackTrace,
        tag: tag,
        shouldSaveLog: shouldSaveLog,
      );

  @override
  void logError(
    dynamic error, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  }) =>
      _errorHandler.logEvent(
        Level.error,
        error.toString(),
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        error: error,
        stack: stackTrace,
        tag: tag,
        shouldSaveLog: shouldSaveLog,
      );

  @override
  void logInfo(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  }) =>
      _errorHandler.logEvent(
        Level.info,
        message,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        error: error,
        stack: stackTrace,
        tag: tag,
        shouldSaveLog: shouldSaveLog,
      );

  @override
  void logVerbose(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  }) =>
      _errorHandler.logEvent(
        Level.trace,
        message,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        error: error,
        stack: stackTrace,
        tag: tag,
        shouldSaveLog: shouldSaveLog,
      );

  @override
  void logWarning(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  }) =>
      _errorHandler.logEvent(
        Level.warning,
        message,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        error: error,
        stack: stackTrace,
        tag: tag,
        shouldSaveLog: shouldSaveLog,
      );

  @override
  void logWtf(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  }) =>
      _errorHandler.logEvent(
        Level.fatal,
        message,
        shouldLog: shouldLog,
        shouldTrackLog: shouldTrackLog,
        error: error,
        stack: stackTrace,
        tag: tag,
        shouldSaveLog: shouldSaveLog,
      );
}

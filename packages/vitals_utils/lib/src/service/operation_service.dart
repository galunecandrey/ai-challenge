import 'package:dartz/dartz.dart';
import 'package:vitals_utils/src/error/base_error.dart';

abstract class OperationService {
  Future<Either<BaseError, T>> safeAsyncOp<T>(
    Future<T> Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  });

  Future<Either<BaseError, Unit>> safeUnitAsyncOp(
    Future<dynamic> Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  });

  Either<BaseError, T> safeSyncOp<T>(
    T Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  });

  Either<BaseError, Unit> safeUnitSyncOp(
    dynamic Function() operation, {
    String? tag,
    bool shouldLog = true,
    bool? shouldTrackLog,
    bool? shouldSaveLog,
    bool Function(dynamic error)? trackLogWhen,
    bool Function(dynamic error)? saveLogWhen,
  });

  void logError(
    dynamic error, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  });

  void logInfo(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  });

  void logDebug(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  });

  void logWarning(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  });

  void logVerbose(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  });

  void logWtf(
    String message, {
    bool shouldLog = true,
    bool shouldTrackLog = false,
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
    bool? shouldSaveLog,
  });
}

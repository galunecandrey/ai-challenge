import 'package:hive/hive.dart';
import 'package:vitals_core/src/api/storage/base/box_storage.dart' show BoxStorage;
import 'package:vitals_core/src/api/storage/key_storage.dart' show KeyStorage;
import 'package:vitals_core/src/model/error/exception.dart' show StorageClosedException;
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit, left;

abstract base class BaseBoxKeyStorage<T> extends BoxStorage<T> implements KeyStorage<String, T> {
  BaseBoxKeyStorage({
    required super.name,
    required super.operationService,
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.version,
    super.isTest,
    super.secureKey,
    super.initName,
  });

  @override
  Future<Either<BaseError, T>> operator [](String key) => operationService
      .safeAsyncOp(
        () => box.then(
          (b) => b.isOpen ? b.get(key) : null,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then(
        (value) => value.noExistIfNull(),
      );

  @override
  Future<Either<BaseError, T>> call(String key, {T? defaultValue}) => operationService
      .safeAsyncOp(
        () => box.then(
          (b) => b.isOpen
              ? b.get(
                  key,
                  defaultValue: defaultValue,
                )
              : null,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then(
        (value) => value.noExistIfNull(),
      );

  @override
  Future<Either<BaseError, Unit>> clean() => clear();

  @override
  Future<bool> contains(String key) => operationService
      .safeAsyncOp(
        () => box.then(
          (b) => b.isOpen && b.containsKey(key),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then((value) => value.getOrElse(() => false));

  @override
  Future<Either<BaseError, Unit>> delete(String key) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isOpen ? b.delete(key) : Future<void>.value(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteKeys(List<String> keys) => operationService.safeUnitAsyncOp(
        () => keys.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isOpen ? b.deleteAll(keys) : Future<void>.value(),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, T>> get(String key, {T? defaultValue}) => operationService
      .safeAsyncOp(
        () => box.then(
          (b) => b.isOpen
              ? b.get(
                  key,
                  defaultValue: defaultValue,
                )
              : null,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then(
        (value) => value.noExistIfNull(),
      );

  @override
  Future<Either<BaseError, Map<String, T>>> getAll() => operationService.safeAsyncOp(
        () => box.then(
          (value) => value.isOpen ? value.toMap().cast<String, T>() : <String, T>{},
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> replaceAll(Map<String, T> data) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) {
            if (b.isOpen) {
              return;
            }
            final deleteMap = b.toMap()..removeWhere((dynamic key, value) => data.containsKey(key));
            b
              ..putAll(data)
              ..deleteAll(deleteMap.keys);
          },
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> set(String key, T value) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isOpen ? b.put(key, value) : Future<void>.value(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> setAll(Map<String, T> data) => operationService.safeUnitAsyncOp(
        () => data.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isOpen ? b.putAll(data..removeWhere((key, value) => value == null)) : Future<void>.value(),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Stream<Either<BaseError, Map<String, T>>> streamAll({bool sendFirst = false}) async* {
    final b = await box;
    if (!b.isOpen) {
      yield left<BaseError, Map<String, T>>(BaseError(error: const StorageClosedException()));
      return;
    }
    if (sendFirst) {
      yield operationService.safeSyncOp(
        () => b.toMap().cast<String, T>(),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );
    }
    yield* operationService
        .safeSyncOp(
          b.watch,
          tag: tag,
          trackLogWhen: _shouldTrackLog,
        )
        .fold(
          (l) => Stream.value(left(l)),
          (r) => r.map(
            (event) => operationService.safeSyncOp(
              () => b.isOpen ? b.toMap().cast<String, T>() : <String, T>{},
              tag: tag,
            ),
          ),
        );
  }

  @override
  Stream<Either<BaseError, T>> streamKey(String key, {bool sendFirst = false}) async* {
    final b = await box;
    if (!b.isOpen) {
      yield left<BaseError, T>(BaseError(error: const StorageClosedException()));
      return;
    }
    if (sendFirst) {
      yield operationService
          .safeSyncOp(
            () => b.get(key),
            tag: tag,
            trackLogWhen: _shouldTrackLog,
          )
          .noExistIfNull();
    }
    yield* operationService
        .safeSyncOp(
          () => b.watch(key: key),
          tag: tag,
          trackLogWhen: _shouldTrackLog,
        )
        .fold(
          (l) => Stream.value(left(l)),
          (r) => r.map(
            (event) => operationService
                .safeSyncOp(
                  () => b.isOpen ? b.get(key) : null,
                  tag: tag,
                )
                .noExistIfNull(),
          ),
        );
  }

  @override
  Stream<Map<String, Either<BaseError, T>>> streamKeys(
    List<String> keys, {
    dynamic defaultValue,
    bool sendFirst = false,
  }) async* {
    final b = await box;
    if (!b.isOpen) {
      yield <String, Either<BaseError, T>>{
        for (final key in keys) key: left<BaseError, T>(BaseError(error: const StorageClosedException())),
      };
      return;
    }
    if (sendFirst) {
      yield {
        for (final key in keys)
          key: operationService
              .safeSyncOp(
                () => b.get(key),
                tag: tag,
                trackLogWhen: _shouldTrackLog,
              )
              .noExistIfNull(),
      };
    }
    yield* operationService
        .safeSyncOp(
          b.watch,
          tag: tag,
          trackLogWhen: _shouldTrackLog,
        )
        .fold(
          (l) => Stream.value({
            for (final key in keys) key: left(l),
          }),
          (r) => r.map(
            (event) => {
              if (b.isOpen)
                for (final key in keys)
                  key: operationService
                      .safeSyncOp(
                        () => b.get(key),
                        tag: tag,
                      )
                      .noExistIfNull()
              else
                for (final key in keys) key: left<BaseError, T>(BaseError(error: const StorageClosedException())),
            },
          ),
        );
  }

  @override
  Future<bool> get isEmpty => operationService
      .safeAsyncOp(
        () => box.then(
          (b) => !b.isOpen || b.isEmpty,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then((value) => value.getOrElse(() => true));

  bool _shouldTrackLog(dynamic e) => !(e is HiveError && e.message == 'Box has already been closed.');
}

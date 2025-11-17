import 'package:hive/hive.dart';
import 'package:vitals_core/src/api/storage/base/box_storage.dart' show BoxStorage;
import 'package:vitals_core/src/api/storage/database/dao/base/base_dao.dart' show BaseDao;
import 'package:vitals_core/src/model/error/exception.dart' show StorageClosedException;
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit, left;

abstract base class BaseBoxStorage<T> extends BoxStorage<T> implements BaseDao<T> {
  BaseBoxStorage({
    required super.name,
    required super.operationService,
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.version,
    super.isTest,
    super.secureKey,
    super.initName,
  });

  String getBoxKey(T data);

  @override
  Future<Either<BaseError, Unit>> add(T value) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isOpen ? b.put(getBoxKey(value), value) : Future<void>.value(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> addAll(List<T> values) => operationService.safeUnitAsyncOp(
        () => values.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isOpen
                    ? b.putAll(<String, T>{
                        for (final user in values) getBoxKey(user): user,
                      })
                    : Future<void>.value(),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> replaceAll(List<T> values) => operationService.safeUnitAsyncOp(
        () => box.then<dynamic>((b) {
          if (!b.isOpen) {
            return Future<void>.value();
          }
          final oldMap = b.toMap();
          final newMap = <String, T>{};
          for (final user in values) {
            final boxKey = getBoxKey(user);
            newMap[boxKey] = user;
            oldMap.remove(boxKey);
          }

          return Future.wait([
            b.putAll(newMap),
            b.deleteAll(oldMap.keys),
          ]);
        }),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteById(String id) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isOpen ? b.delete(id) : Future<void>.value(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteByIds(List<String> ids) => operationService.safeUnitAsyncOp(
        () => ids.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isOpen ? b.deleteAll(ids) : Future<void>.value(),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, List<T>>> getAll() => operationService.safeAsyncOp(
        () => box.then<List<T>>((b) => b.isOpen ? b.values.toList() : <T>[]),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, T>> getById(String id) => operationService
      .safeAsyncOp(
        () => box.then<T?>(
          (b) => b.isOpen ? b.get(id) : null,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then(
        (value) => value.noExistIfNull(),
      );

  @override
  Stream<Either<BaseError, List<T>>> streamAll({bool sendFirst = false}) async* {
    final b = await box;
    if (!b.isOpen) {
      yield left<BaseError, List<T>>(BaseError(error: const StorageClosedException()));
      return;
    }
    if (sendFirst) {
      yield operationService.safeSyncOp(
        () => b.values.toList(),
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
              () => b.isOpen ? b.values.toList() : <T>[],
              tag: tag,
            ),
          ),
        );
  }

  @override
  Stream<Either<BaseError, T>> streamById(String id, {bool sendFirst = false}) async* {
    final b = await box;
    if (!b.isOpen) {
      yield left<BaseError, T>(BaseError(error: const StorageClosedException()));
      return;
    }
    if (sendFirst) {
      yield operationService
          .safeSyncOp(
            () => b.get(id),
            tag: tag,
            trackLogWhen: _shouldTrackLog,
          )
          .noExistIfNull();
    }
    yield* operationService
        .safeSyncOp(
          () => b.watch(key: id),
          tag: tag,
          trackLogWhen: _shouldTrackLog,
        )
        .fold(
          (l) => Stream.value(left(l)),
          (r) => r.map(
            (event) => operationService
                .safeSyncOp(
                  () => b.get(id),
                  tag: tag,
                )
                .noExistIfNull(),
          ),
        );
  }

  @override
  Future<Either<BaseError, bool>> isEmpty() => operationService.safeAsyncOp(
        () => box.then((b) => !b.isOpen || b.isEmpty),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, int>> size() => operationService.safeAsyncOp(
        () => box.then((b) => b.isOpen ? b.length : 0),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, bool>> containsId(String id) => operationService.safeAsyncOp(
        () => box.then(
          (b) => b.isOpen && b.containsKey(id),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  bool _shouldTrackLog(dynamic e) => !(e is HiveError && e.message == 'Box has already been closed.');
}

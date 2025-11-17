import 'package:hive/hive.dart';
import 'package:vitals_core/src/api/storage/base/box_storage.dart' show BoxStorage;
import 'package:vitals_core/src/api/storage/database/dao/base/single_base_dao.dart' show SingleBaseDao;
import 'package:vitals_core/src/model/error/exception.dart' show StorageClosedException;
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit, left;

abstract base class SingleBaseBoxStorage<T> extends BoxStorage<T> implements SingleBaseDao<T> {
  SingleBaseBoxStorage({
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
  Future<Either<BaseError, Unit>> update(T value) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isOpen ? b.put(0, value) : Future<void>.value(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> delete() => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isOpen ? b.delete(0) : Future<void>.value(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, T>> get() => operationService
      .safeAsyncOp(
        () => box.then<T?>(
          (b) => b.isOpen ? b.get(0) : null,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then(
        (value) => value.noExistIfNull(),
      );

  @override
  Stream<Either<BaseError, T>> stream({bool sendFirst = false}) async* {
    final b = await box;
    if (!b.isOpen) {
      yield left<BaseError, T>(BaseError(error: const StorageClosedException()));
      return;
    }
    if (sendFirst) {
      yield operationService
          .safeSyncOp(
            () => b.get(0),
            tag: tag,
            trackLogWhen: _shouldTrackLog,
          )
          .noExistIfNull();
    }
    yield* operationService
        .safeSyncOp(
          () => b.watch(key: 0),
          tag: tag,
          trackLogWhen: _shouldTrackLog,
        )
        .fold(
          (l) => Stream.value(left(l)),
          (r) => r.map(
            (event) => operationService
                .safeSyncOp(
                  () => b.isOpen ? b.get(0) : null,
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

  bool _shouldTrackLog(dynamic e) => !(e is HiveError && e.message == 'Box has already been closed.');
}

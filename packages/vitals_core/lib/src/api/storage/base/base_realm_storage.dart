import 'package:realm/realm.dart';
import 'package:vitals_core/src/api/storage/base/realm_storage.dart' show RealmStorage;
import 'package:vitals_core/src/api/storage/database/dao/base/base_async_dao.dart' show BaseAsyncDao;
import 'package:vitals_core/src/api/storage/database/dao/base/base_dao.dart' show BaseDao;
import 'package:vitals_core/src/api/storage/database/dao/base/query_async_dao.dart' show QueryAsyncDao;
import 'package:vitals_core/src/api/storage/database/dao/base/query_dao.dart' show QueryDao;
import 'package:vitals_core/src/model/error/exception.dart' show StorageClosedException;
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, ListExt, Unit, left, unit;

abstract class BaseRealmStorage<T, E extends RealmObject> extends RealmStorage<E>
    implements BaseDao<T>, QueryDao<T>, BaseAsyncDao<T>, QueryAsyncDao<T> {
  BaseRealmStorage({
    required super.name,
    required super.operationService,
    required super.dbProvider,
    super.secureKeyStorage,
    super.isTest,
    super.isMemory,
    super.initName,
    super.dir,
    super.schemaObjects,
    super.schemaVersion,
  });

  T mapFromEntity(E data);

  E mapToEntity(T data);

  String getModelId(T data);

  @override
  Future<Either<BaseError, Unit>> add(T value) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? value
              : b.write(
                  () => b.add(
                    mapToEntity(value),
                    update: true,
                  ),
                ),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> addAsync(T value) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? Future<T>.value(value)
              : b.writeAsync(
                  () => b.add(
                    mapToEntity(value),
                    update: true,
                  ),
                ),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> addAll(List<T> values) => operationService.safeUnitAsyncOp(
        () => values.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isClosed
                    ? unit
                    : b.write(
                        () => b.addAll(
                          values.map(mapToEntity),
                          update: true,
                        ),
                      ),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> addAllAsync(List<T> values) => operationService.safeUnitAsyncOp(
        () => values.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isClosed
                    ? Future<void>.value()
                    : b.writeAsync(
                        () => b.addAll(
                          values.map(mapToEntity),
                          update: true,
                        ),
                      ),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> replaceAll(List<T> values) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? unit
              : b.write(() {
                  b.deleteAll<E>();
                  return b.addAll(
                    values.map(mapToEntity),
                    update: true,
                  );
                }),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> replaceAllAsync(List<T> values) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? Future<void>.value()
              : b.writeAsync(() {
                  b.deleteAll<E>();
                  return b.addAll(
                    values.map(mapToEntity),
                    update: true,
                  );
                }),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> replaceQuery(
    List<T> values, {
    required String query,
  }) =>
      operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? unit
              : b.write(() {
                  b.deleteMany<E>(
                    b.query<E>(query),
                  );
                  return b.addAll(
                    values.map(mapToEntity),
                    update: true,
                  );
                }),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> replaceQueryAsync(
    List<T> values, {
    required String query,
  }) =>
      operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? Future<void>.value()
              : b.writeAsync(() {
                  b.deleteMany<E>(
                    b.query<E>(query),
                  );
                  return b.addAll(
                    values.map(mapToEntity),
                    update: true,
                  );
                }),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteById(String id) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? unit
              : b.write(() {
                  final entity = b.find<E>(id);
                  if (entity != null) {
                    b.delete<E>(entity);
                  }
                }),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteByIdAsync(String id) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed
              ? Future<void>.value()
              : b.writeAsync(() {
                  final entity = b.find<E>(id);
                  if (entity != null) {
                    b.delete<E>(entity);
                  }
                }),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteByIds(List<String> ids) => operationService.safeUnitAsyncOp(
        () => ids.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isClosed
                    ? unit
                    : b.write(
                        () => b.deleteMany<E>(
                          b.query<E>(
                            '_id IN {${ids.map((e) => "'$e'").join(', ')}}',
                          ),
                        ),
                      ),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteByIdsAsync(List<String> ids) => operationService.safeUnitAsyncOp(
        () => ids.isEmpty
            ? Future<void>.value()
            : box.then<void>(
                (b) => b.isClosed
                    ? Future<void>.value()
                    : b.writeAsync(
                        () => b.deleteMany<E>(
                          b.query<E>(
                            '_id IN {${ids.map((e) => "'$e'").join(', ')}}',
                          ),
                        ),
                      ),
              ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteQuery(String query) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed ? unit : b.write(() => b.deleteMany<E>(b.query<E>(query))),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, Unit>> deleteQueryAsync(String query) => operationService.safeUnitAsyncOp(
        () => box.then<void>(
          (b) => b.isClosed ? Future<void>.value() : b.writeAsync(() => b.deleteMany<E>(b.query<E>(query))),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, List<T>>> getAll() => operationService.safeAsyncOp(
        () => box.then<List<T>>(
          (b) => b.isClosed ? <T>[] : b.all<E>().map(mapFromEntity).toList(),
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, List<T>>> query(String query) => operationService.safeAsyncOp(
        () => box.then<List<T>>((b) => b.isClosed ? <T>[] : b.query<E>(query).map(mapFromEntity).toList()),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, T>> querySingle(String query) => operationService
      .safeAsyncOp(
        () => box.then<T?>((b) => b.isClosed ? null : b.query<E>(query).map(mapFromEntity).toList().firstNullable),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      )
      .then((value) => value.noExistIfNull());

  @override
  Future<Either<BaseError, T>> getById(String id) => operationService
      .safeAsyncOp(
        () => box.then<T?>(
          (b) {
            if (b.isClosed) {
              return null;
            }
            final result = b.find<E>(id);
            if (result != null) {
              return mapFromEntity(result);
            }
            return null;
          },
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
    if (b.isClosed) {
      yield left<BaseError, List<T>>(BaseError(error: const StorageClosedException()));
      return;
    }

    yield* operationService
        .safeSyncOp(
      () => b.all<E>(),
      tag: tag,
      trackLogWhen: _shouldTrackLog,
    )
        .fold(
      (l) async* {
        yield left<BaseError, List<T>>(l);
      },
      (r) async* {
        if (sendFirst) {
          yield operationService.safeSyncOp(
            () => r.map(mapFromEntity).toList(),
            tag: tag,
          );
        }
        yield* r.changes.map(
          (e) => operationService.safeSyncOp(
            () => e.results.map(mapFromEntity).toList(),
            tag: tag,
          ),
        );
      },
    );
  }

  @override
  Stream<Either<BaseError, T>> streamById(String id, {bool sendFirst = false}) async* {
    final b = await box;

    if (b.isClosed) {
      yield left<BaseError, T>(BaseError(error: const StorageClosedException()));
      return;
    }

    yield* operationService
        .safeSyncOp(
      () => b.query<E>('_id == \$0', [id]),
      tag: tag,
      trackLogWhen: _shouldTrackLog,
    )
        .fold(
      (l) async* {
        yield left<BaseError, T>(l);
      },
      (r) async* {
        if (sendFirst) {
          yield operationService
              .safeSyncOp(
                () => r.map(mapFromEntity).toList().firstNullable,
                tag: tag,
              )
              .noExistIfNull();
        }
        yield* r.changes.map(
          (e) => operationService
              .safeSyncOp(
                () => e.results.map(mapFromEntity).toList().firstNullable,
                tag: tag,
              )
              .noExistIfNull(),
        );
      },
    );
  }

  @override
  Stream<Either<BaseError, List<T>>> streamQuery(String query, {bool sendFirst = false}) async* {
    final b = await box;

    if (b.isClosed) {
      yield left<BaseError, List<T>>(BaseError(error: const StorageClosedException()));
      return;
    }

    yield* operationService
        .safeSyncOp(
      () => b.query<E>(query),
      tag: tag,
      trackLogWhen: _shouldTrackLog,
    )
        .fold(
      (l) async* {
        yield left<BaseError, List<T>>(l);
      },
      (r) async* {
        if (sendFirst) {
          yield operationService.safeSyncOp(
            () => r.map(mapFromEntity).toList(),
            tag: tag,
          );
        }
        yield* r.changes.map(
          (e) => operationService.safeSyncOp(
            () => e.results.map(mapFromEntity).toList(),
            tag: tag,
          ),
        );
      },
    );
  }

  @override
  Stream<Either<BaseError, T>> streamQuerySingle(String query, {bool sendFirst = false}) async* {
    final b = await box;

    if (b.isClosed) {
      yield left<BaseError, T>(BaseError(error: const StorageClosedException()));
      return;
    }

    yield* operationService
        .safeSyncOp(
      () => b.query<E>(query),
      tag: tag,
      trackLogWhen: _shouldTrackLog,
    )
        .fold(
      (l) async* {
        yield left<BaseError, T>(l);
      },
      (r) async* {
        if (sendFirst) {
          yield operationService
              .safeSyncOp(
                () => r.map(mapFromEntity).toList().firstNullable,
                tag: tag,
              )
              .noExistIfNull();
        }
        yield* r.changes.map(
          (e) => operationService
              .safeSyncOp(
                () => e.results.map(mapFromEntity).toList().firstNullable,
                tag: tag,
              )
              .noExistIfNull(),
        );
      },
    );
  }

  @override
  Future<Either<BaseError, bool>> isEmpty() => operationService.safeAsyncOp(
        () => box.then((b) => b.isClosed || b.all<E>().isEmpty),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, bool>> isQueryEmpty(String query) => operationService.safeAsyncOp(
        () => box.then((b) => b.isClosed || b.query<E>(query).isEmpty),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, bool>> containsId(String id) => operationService.safeAsyncOp(
        () => box.then(
          (b) => !b.isClosed && b.find<E>(id) != null,
        ),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, int>> size() => operationService.safeAsyncOp(
        () => box.then((b) => b.isClosed ? 0 : b.all<E>().length),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  @override
  Future<Either<BaseError, int>> querySize(String query) => operationService.safeAsyncOp(
        () => box.then((b) => b.isClosed ? 0 : b.query<E>(query).length),
        tag: tag,
        trackLogWhen: _shouldTrackLog,
      );

  bool _shouldTrackLog(dynamic e) => e is! RealmClosedError;
}

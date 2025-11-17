import 'package:realm/realm.dart';
import 'package:vitals_core/src/api/storage/base/base_realm_storage.dart' show BaseRealmStorage;
import 'package:vitals_core/src/utils/either.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Rx, StreamMap, Unit, left, right;

abstract base class BaseRealmWithCacheStorage<T, E extends RealmObject> extends BaseRealmStorage<T, E> {
  //ignore: close_sinks
  StreamMap<String, T>? _cache;

  StreamMap<String, T> get cache {
    _cache ??= StreamMap<String, T>();
    return _cache!;
  }

  BaseRealmWithCacheStorage({
    required super.name,
    required super.operationService,
    required super.dbProvider,
    required super.secureKeyStorage,
    super.isTest,
    super.isMemory,
    super.initName,
  });

  bool shouldSave(T data);

  @override
  Future<Either<BaseError, Unit>> add(T value) {
    if (shouldSave(value)) {
      return super.add(value);
    } else {
      return operationService.safeUnitAsyncOp(
        () async {
          cache[getModelId(value)] = value;
        },
        tag: tag,
      );
    }
  }

  @override
  Future<Either<BaseError, Unit>> deleteById(String id) {
    operationService.safeSyncOp(
      () => cache.remove(id),
      tag: tag,
    );
    return super.deleteById(id);
  }

  @override
  Future<Either<BaseError, T>> getById(String id) => super.getById(id).then(
        (value) => value.fold(
          (l) {
            if (cache.containsKey(id)) {
              return operationService.safeSyncOp(
                () => cache[id]!,
                tag: tag,
              );
            } else {
              return left(l);
            }
          },
          (r) => right(r),
        ),
      );

  @override
  Stream<Either<BaseError, T>> streamById(String id, {bool sendFirst = false}) => Rx.combineLatest2(
        cache(sendFirst: true).map((e) => e[id]).distinct().map((e) => e.noExistIfNull()),
        super.streamById(id, sendFirst: true),
        (a, b) {
          if (a.isRight()) {
            return a;
          }
          return b;
        },
      ).skip(sendFirst ? 0 : 1);

  @override
  Future<Either<BaseError, bool>> containsId(String id) {
    final result = operationService.safeSyncOp(
      () => cache.containsKey(id),
      tag: tag,
    );
    if (result.getOrElse(() => false)) {
      return Future.value(result);
    }
    return super.containsId(id);
  }

  @override
  Future<Either<BaseError, Unit>> init([String? id]) {
    if (id != daoId) {
      operationService.safeSyncOp(
        cache.clear,
        tag: tag,
      );
    }
    return super.init(id);
  }

  @override
  Future<Either<BaseError, Unit>> clear() {
    operationService.safeSyncOp(
      cache.clear,
      tag: tag,
    );
    return super.clear();
  }

  @override
  Future<Either<BaseError, Unit>> close() {
    operationService.safeSyncOp(
      () {
        cache.close();
        _cache = null;
      },
      tag: tag,
    );
    return super.close();
  }
}

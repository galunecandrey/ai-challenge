// ignore: one_member_abstracts
// ignore_for_file: only_throw_errors

import 'package:vitals_core/src/api/storage/base/base_part_combined_dao.dart' show BasePartCombinedDao;
import 'package:vitals_core/src/api/storage/base/combined_key_storage.dart' show CombinedKeyStorage;
import 'package:vitals_core/src/api/storage/database/dao/base/base_combined_dao.dart' show BaseCombinedDao;
import 'package:vitals_core/src/api/storage/database/dao/base/base_dao.dart' show BaseDao;
import 'package:vitals_core/src/impl/providers/vis_db_provider.dart' show DBProvider;
import 'package:vitals_core/src/impl/storages/memory/secure_key_storage.dart' show SecureKeyStorage;
import 'package:vitals_utils/vitals_utils.dart'
    show BaseError, Either, OperationService, SwitchMapExtension, Unit, left, right, unit;

abstract base class BaseBoxCombinedDao<T> implements BaseCombinedDao<T> {
  final String _name;

  String? _id;

  final _cache = <String, BaseDao<T>>{};

  final OperationService operationService;

  late final BaseDao<T> Function(String name) _openDao;

  late final CombinedKeyStorage _keyStorage;

  @override
  String? get daoId => _id;

  String get name => _name;

  String get tag => 'CombinedBox(id: $daoId, name: $_name)';

  BaseBoxCombinedDao({
    required String name,
    required this.operationService,
    required DBProvider dbProvider,
    required SecureKeyStorage secureKeyStorage,
    required int version,
    BaseDao<T> Function(String)? openDao,
    bool isTest = false,
    String? secureKey,
  })  : _name = name,
        _keyStorage = CombinedKeyStorage(
          name: name,
          dbProvider: dbProvider,
          secureKeyStorage: secureKeyStorage,
          operationService: operationService,
          isTest: isTest,
          secureKey: secureKey,
          version: version,
        ) {
    _openDao = openDao ??
        (initName) => BasePartCombinedDao<T>(
              name: name,
              dbProvider: dbProvider,
              secureKeyStorage: secureKeyStorage,
              operationService: operationService,
              isTest: isTest,
              initName: initName,
              getBoxKey: getBoxKey,
              secureKey: secureKey,
              version: version,
            );
  }

  String getBoxKey(T data);

  BaseDao<T> getDao(String daoKey) {
    final key = '${_id}_$daoKey';
    _cache[key] ??= _openDao(key);
    return _cache[key]!;
  }

  Future<Either<BaseError, BaseDao<T>>> getDaoById(String id) => _keyStorage.get(id).then(
        (value) => value.map(
          (r) => getDao(r),
        ),
      );

  @override
  Future<Either<BaseError, Unit>> init([String? id]) {
    if (_id == id) {
      return Future.value(right(unit));
    }
    _id = id;
    return operationService.safeUnitAsyncOp(
      () => Future.wait([
        _keyStorage.init(id),
        for (final dao in _cache.values) dao.close(),
      ]).then<dynamic>(
        (values) {
          for (final value in values) {
            value.leftMap<BaseError>((l) => l.reThrow());
          }
          _cache.clear();
        },
      ),
      tag: tag,
    );
  }

  @override
  Future<Either<BaseError, Unit>> clear() => operationService.safeUnitAsyncOp(
        () => _keyStorage.getAll().then<dynamic>((value) async {
          final map = value.fold((l) => l.reThrow<Map<String, String>>(), (r) => r);
          for (final daoKey in map.values.toSet()) {
            await getDao(daoKey).clear().then((value) => value.leftMap<BaseError>((l) => l.reThrow<BaseError>()));
          }
        }),
        tag: tag,
      );

  @override
  Future<Either<BaseError, Unit>> close() {
    _id = null;
    return operationService.safeUnitAsyncOp(
      () => Future.wait(
        [
          _keyStorage.close(),
          for (final dao in _cache.values) dao.close(),
        ],
      ).then<dynamic>(
        (values) {
          for (final value in values) {
            value.leftMap<BaseError>((l) => l.reThrow());
          }
          _cache.clear();
        },
      ),
      tag: tag,
    );
  }

  @override
  Future<Either<BaseError, Unit>> add(T value) => operationService.safeUnitAsyncOp(
        () async {
          final key = getBoxKey(value);
          final daoKey = getDaoKey(value);
          final savedDaoKey = await _keyStorage.get(key, defaultValue: daoKey).then<String>(
                (value) => value.fold(
                  (l) => l.reThrow(),
                  (r) => r,
                ),
              );
          if (savedDaoKey != daoKey) {
            await getDao(savedDaoKey).deleteById(key).then((value) {
              value.leftMap<BaseError>((l) => l.reThrow());
            });
          }
          await Future.wait([
            _keyStorage.set(key, daoKey),
            getDao(daoKey).add(value),
          ]).then<dynamic>((values) {
            for (final value in values) {
              value.leftMap<BaseError>(
                (l) => l.reThrow(),
              );
            }
          });
        },
        tag: tag,
      );

  @override
  Future<Either<BaseError, Unit>> addAll(
    List<T> values,
  ) =>
      operationService.safeUnitAsyncOp(
        () async {
          if (values.isEmpty) {
            return;
          }
          final map = await _keyStorage.getAll().then((value) => value.getOrElse(() => {}));
          final deleteDaoMap = <String, List<String>>{};
          final addMap = <String, String>{};
          final addDaoMap = <String, List<T>>{};
          for (final value in values) {
            final daoKey = getDaoKey(value);
            final boxKey = getBoxKey(value);
            final saved = map[boxKey];
            addMap[boxKey] = daoKey;
            addDaoMap[daoKey] = (addDaoMap[daoKey]?..add(value)) ?? [value];
            if (saved != null && saved != daoKey) {
              deleteDaoMap[saved] = (deleteDaoMap[saved]?..add(boxKey)) ?? [boxKey];
            }
          }

          return Future.wait([
            _keyStorage.setAll(addMap),
            for (final entry in deleteDaoMap.entries) getDao(entry.key).deleteByIds(entry.value),
            for (final entry in addDaoMap.entries) getDao(entry.key).addAll(entry.value),
          ]).then<dynamic>((values) {
            for (final value in values) {
              value.leftMap<BaseError>((l) => l.reThrow());
            }
          });
        },
        tag: tag,
      );

  @override
  Future<Either<BaseError, Unit>> replaceAll(List<T> values, {String? daoKey}) =>
      daoKey == null ? _replaceAll(values) : _replaceAllDao(daoKey, values);

  Future<Either<BaseError, Unit>> _replaceAll(List<T> values) => operationService.safeUnitAsyncOp(
        () async {
          final map = await _keyStorage.getAll().then((value) => value.getOrElse(() => {}));
          final replaceMap = <String, String>{};
          final replaceDaoMap = <String, List<T>>{};
          for (final value in values) {
            final daoKey = getDaoKey(value);
            final boxKey = getBoxKey(value);
            replaceMap[boxKey] = daoKey;
            replaceDaoMap[daoKey] = (replaceDaoMap[daoKey]?..add(value)) ?? [value];
            map.remove(boxKey);
          }

          final clearList = map.values.toSet().where((e) => !replaceDaoMap.containsKey(e));

          return Future.wait([
            _keyStorage.replaceAll(replaceMap),
            for (final entry in clearList) getDao(entry).clear(),
            for (final entry in replaceDaoMap.entries) getDao(entry.key).replaceAll(entry.value),
          ]).then<dynamic>((values) {
            for (final value in values) {
              value.leftMap<BaseError>((l) => l.reThrow());
            }
          });
        },
        tag: tag,
      );

  Future<Either<BaseError, Unit>> _replaceAllDao(String daoKey, List<T> values) => operationService.safeUnitAsyncOp(
        () async {
          final map = await _keyStorage.getAll().then((value) => value.getOrElse(() => {}));
          final deleteDaoMap = <String, List<String>>{};
          final addMap = <String, String>{};
          final replaceList = <T>[];
          for (final value in values) {
            final valueDaoKey = getDaoKey(value);
            if (daoKey == valueDaoKey) {
              final boxKey = getBoxKey(value);
              final saved = map[boxKey];
              addMap[boxKey] = daoKey;
              replaceList.add(value);
              if (saved != null && saved != daoKey) {
                deleteDaoMap[saved] = (deleteDaoMap[saved]?..add(boxKey)) ?? [boxKey];
              }
            }
          }

          map.removeWhere((key, value) => value != daoKey || addMap.containsKey(key));

          return Future.wait([
            _keyStorage.setAll(addMap),
            _keyStorage.deleteKeys(map.keys.toList()),
            for (final entry in deleteDaoMap.entries) getDao(entry.key).deleteByIds(entry.value),
            getDao(daoKey).replaceAll(replaceList),
          ]).then<dynamic>((values) {
            for (final value in values) {
              value.leftMap<BaseError>((l) => l.reThrow());
            }
          });
        },
        tag: tag,
      );

  @override
  Future<Either<BaseError, Unit>> clean(String daoKey) => operationService.safeUnitAsyncOp(
        () async {
          final map = await _keyStorage.getAll().then((value) => value.getOrElse(() => {}));

          map.removeWhere((key, value) => value != daoKey);

          return Future.wait([
            _keyStorage.deleteKeys(map.keys.toList()),
            getDao(daoKey).clear(),
          ]).then<dynamic>((values) {
            for (final value in values) {
              value.leftMap<BaseError>((l) => l.reThrow());
            }
          });
        },
        tag: tag,
      );

  @override
  Future<Either<BaseError, bool>> containsId(String id) => operationService.safeAsyncOp(
        () => _keyStorage.contains(id),
        tag: tag,
      );

  @override
  Future<Either<BaseError, Unit>> deleteById(String id) => operationService.safeUnitAsyncOp(
        () => getDaoById(id).then<dynamic>(
          (value) => value.fold(
            (l) async => l.reThrow(),
            (r) => Future.wait(
              [
                _keyStorage.delete(id),
                r.deleteById(id),
              ],
            ).then<dynamic>((values) {
              for (final value in values) {
                value.leftMap<BaseError>((l) => l.reThrow());
              }
            }),
          ),
        ),
        tag: tag,
      );

  @override
  Future<Either<BaseError, Unit>> deleteByIds(List<String> ids) => operationService.safeUnitAsyncOp(
        () => ids.isEmpty
            ? operationService.safeUnitAsyncOp(
                () async {},
                tag: tag,
              )
            : _keyStorage.getAll().then<dynamic>(
                  (value) => value.fold(
                    (l) async => l.reThrow(),
                    (r) {
                      final map = r;
                      final deleteDaoMap = <String, List<String>>{};
                      for (final id in ids) {
                        final saved = map[id];
                        if (saved != null) {
                          deleteDaoMap[saved] = (deleteDaoMap[saved]?..add(id)) ?? [id];
                        }
                      }
                      return Future.wait(
                        [
                          _keyStorage.deleteKeys(
                            ids,
                          ),
                          for (final entry in deleteDaoMap.entries) getDao(entry.key).deleteByIds(entry.value),
                        ],
                      ).then<dynamic>(
                        (values) {
                          for (final value in values) {
                            value.leftMap<BaseError>((l) => l.reThrow());
                          }
                        },
                      );
                    },
                  ),
                ),
        tag: tag,
      );

  @override
  Future<Either<BaseError, List<T>>> getAll({String? daoKey}) => daoKey == null ? _getAll() : _getAllFromDao(daoKey);

  Future<Either<BaseError, List<T>>> _getAll() => operationService.safeAsyncOp(
        () => _keyStorage.getAll().then(
              (map) => map.fold(
                (l) async => l.reThrow(),
                (r) => Future.wait([
                  for (final daoKey in r.values.toSet()) getDao(daoKey).getAll(),
                ]).then(
                  (values) => [
                    for (final value in values)
                      ...value.fold(
                        (l) => l.reThrow(),
                        (r) => r,
                      ),
                  ],
                ),
              ),
            ),
        tag: tag,
      );

  Future<Either<BaseError, List<T>>> _getAllFromDao(String daoKey) => getDao(daoKey).getAll();

  @override
  Future<Either<BaseError, T>> getById(String id) => getDaoById(id).then(
        (value) => value.fold(
          (l) async => left(l),
          (r) => r.getById(id),
        ),
      );

  @override
  Future<Either<BaseError, bool>> isEmpty({String? daoKey}) => daoKey == null ? _isEmpty() : _isEmptyDao(daoKey);

  Future<Either<BaseError, bool>> _isEmpty() => operationService.safeAsyncOp(
        () => _keyStorage.isEmpty,
        tag: tag,
      );

  Future<Either<BaseError, bool>> _isEmptyDao(String daoKey) => getDao(daoKey).isEmpty();

  @override
  Stream<Either<BaseError, T>> streamById(String id, {bool sendFirst = false}) => _keyStorage
      .streamKey(
        id,
        sendFirst: true,
      )
      .distinct()
      .switchMap(
        (r) => r.fold(
          (l) => Stream<Either<BaseError, T>>.value(left(l)),
          (r) => getDao(r).streamById(
            id,
            sendFirst: true,
          ),
        ),
      )
      .skip(sendFirst ? 0 : 1);

  @override
  Stream<Either<BaseError, List<T>>> stream(String daoKey, {bool sendFirst = false}) =>
      getDao(daoKey).streamAll(sendFirst: sendFirst);
}

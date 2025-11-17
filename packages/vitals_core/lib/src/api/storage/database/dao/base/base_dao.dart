// ignore: one_member_abstracts
import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class BaseDao<T> implements Dao {
  Future<Either<BaseError, bool>> containsId(String id);

  Future<Either<BaseError, bool>> isEmpty();

  Future<Either<BaseError, int>> size();

  Future<Either<BaseError, List<T>>> getAll();

  Future<Either<BaseError, T>> getById(String id);

  Future<Either<BaseError, Unit>> add(T value);

  Future<Either<BaseError, Unit>> replaceAll(List<T> values);

  Future<Either<BaseError, Unit>> addAll(List<T> values);

  Future<Either<BaseError, Unit>> deleteById(String id);

  Future<Either<BaseError, Unit>> deleteByIds(List<String> ids);

  Stream<Either<BaseError, T>> streamById(String id, {bool sendFirst = false});

  Stream<Either<BaseError, List<T>>> streamAll({bool sendFirst = false});
}

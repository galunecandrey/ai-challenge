// ignore: one_member_abstracts
import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class BaseAsyncDao<T> implements Dao {
  Future<Either<BaseError, Unit>> addAsync(T value);

  Future<Either<BaseError, Unit>> replaceAllAsync(List<T> values);

  Future<Either<BaseError, Unit>> addAllAsync(List<T> values);

  Future<Either<BaseError, Unit>> deleteByIdAsync(String id);

  Future<Either<BaseError, Unit>> deleteByIdsAsync(List<String> ids);
}

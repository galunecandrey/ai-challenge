import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class SingleBaseDao<T> implements Dao {
  Future<Either<BaseError, T>> get();

  Future<Either<BaseError, Unit>> update(T value);

  Future<Either<BaseError, Unit>> delete();

  Stream<Either<BaseError, T>> stream({bool sendFirst = false});

  Future<Either<BaseError, bool>> isEmpty();
}

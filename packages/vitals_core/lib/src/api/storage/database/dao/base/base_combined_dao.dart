import 'package:vitals_core/src/api/storage/database/dao/base/base_dao.dart' show BaseDao;
import 'package:vitals_core/src/api/storage/database/dao/base/combined_dao.dart' show CombinedDao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class BaseCombinedDao<T> implements CombinedDao<T, BaseDao<T>> {
  Future<Either<BaseError, bool>> containsId(String id);

  Future<Either<BaseError, bool>> isEmpty({String? daoKey});

  Future<Either<BaseError, List<T>>> getAll({String? daoKey});

  Future<Either<BaseError, T>> getById(String id);

  Future<Either<BaseError, Unit>> add(T value);

  Future<Either<BaseError, Unit>> addAll(
    List<T> values,
  );

  Future<Either<BaseError, Unit>> replaceAll(List<T> values, {String? daoKey});

  Future<Either<BaseError, Unit>> deleteById(String id);

  Future<Either<BaseError, Unit>> deleteByIds(List<String> ids);

  Stream<Either<BaseError, T>> streamById(String id, {bool sendFirst = false});

  Stream<Either<BaseError, List<T>>> stream(String daoKey, {bool sendFirst = false});

  Future<Either<BaseError, Unit>> clean(String daoKey);
}

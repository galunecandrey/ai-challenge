// ignore: one_member_abstracts
import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class QueryDao<T> implements Dao {
  Future<Either<BaseError, bool>> isQueryEmpty(String query);

  Future<Either<BaseError, int>> querySize(String query);

  Future<Either<BaseError, List<T>>> query(String query);

  Future<Either<BaseError, T>> querySingle(String query);

  Future<Either<BaseError, Unit>> deleteQuery(String query);

  Future<Either<BaseError, Unit>> replaceQuery(
    List<T> values, {
    required String query,
  });

  Stream<Either<BaseError, List<T>>> streamQuery(String id, {bool sendFirst = false});

  Stream<Either<BaseError, T>> streamQuerySingle(String id, {bool sendFirst = false});
}

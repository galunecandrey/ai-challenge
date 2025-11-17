// ignore: one_member_abstracts
import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class QueryAsyncDao<T> implements Dao {
  Future<Either<BaseError, Unit>> deleteQueryAsync(String query);

  Future<Either<BaseError, Unit>> replaceQueryAsync(
    List<T> values, {
    required String query,
  });
}

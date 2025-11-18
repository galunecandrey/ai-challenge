import 'package:vitals_core/src/api/storage/database/dao/base/dao.dart' show Dao;

abstract interface class CombinedDao<T, D extends Dao> implements Dao {
  String getDaoKey(T model);
}

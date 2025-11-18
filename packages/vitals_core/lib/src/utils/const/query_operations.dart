import 'package:vitals_core/src/model/db_operation/dp_operations.dart' show Limit, Sort;
import 'package:vitals_core/src/model/db_operation/sort_type.dart' show SortType;
import 'package:vitals_core/src/utils/const/query_fields.dart' show kUnixTimeFieldName;

const kTruePredicate = 'TRUEPREDICATE';

//Sort operations
const kSortByUnixTimeAsc = Sort(
  fieldName: kUnixTimeFieldName,
  sortType: SortType.asc,
);

const kSortByUnixTimeDesc = Sort(
  fieldName: kUnixTimeFieldName,
  sortType: SortType.desc,
);

//Limit operations
const kLimit10000 = Limit(10000);

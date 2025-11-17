import 'dart:async';

import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class Dao {
  String? get daoId;

  Future<Either<BaseError, Unit>> init([String? subDir]);

  Future<Either<BaseError, Unit>> close();

  Future<Either<BaseError, Unit>> clear();
}

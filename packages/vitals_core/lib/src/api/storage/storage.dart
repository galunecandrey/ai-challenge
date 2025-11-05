import 'dart:async';

import 'package:vitals_utils/vitals_utils.dart';

abstract interface class Storage<T> {
  FutureOr<Either<BaseError, T>> call();

  FutureOr<Either<BaseError, T>> get({T? defaultValue});

  FutureOr<Either<BaseError, Unit>> set(T value);

  Stream<Either<BaseError, T>> stream({bool sendFirst = false});

  FutureOr<Either<BaseError, Unit>> clean();

  FutureOr<Either<BaseError, Unit>> close();
}

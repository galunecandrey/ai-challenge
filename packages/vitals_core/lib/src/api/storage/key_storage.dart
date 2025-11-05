import 'dart:async';

import 'package:vitals_utils/vitals_utils.dart';


abstract interface class KeyStorage<K, V> {
  FutureOr<bool> contains(K key);

  FutureOr<bool> get isEmpty;

  FutureOr<Either<BaseError, V>> operator [](K key);

  FutureOr<Either<BaseError, V>> call(K key, {V? defaultValue});

  FutureOr<Either<BaseError, V>> get(K key, {V? defaultValue});

  FutureOr<Either<BaseError, Map<K, V>>> getAll();

  FutureOr<Either<BaseError, Unit>> set(K key, V value);

  FutureOr<Either<BaseError, Unit>> setAll(Map<K, V> data);

  FutureOr<Either<BaseError, Unit>> replaceAll(Map<K, V> data);

  FutureOr<Either<BaseError, Unit>> delete(K key);

  FutureOr<Either<BaseError, Unit>> deleteKeys(List<K> keys);

  Stream<Either<BaseError, Map<K, V>>> streamAll({bool sendFirst = false});

  Stream<Either<BaseError, V>> streamKey(K key, {bool sendFirst = false});

  Stream<Map<K, Either<BaseError, V>>> streamKeys(List<K> keys, {V? defaultValue, bool sendFirst = false});

  FutureOr<Either<BaseError, Unit>> clean();

  FutureOr<Either<BaseError, Unit>> close();
}

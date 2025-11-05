import 'dart:async';

import 'package:vitals_utils/vitals_utils.dart';

enum PreloaderState {
  none,
  loading,
  success,
  error,
}

abstract class IdViewModel<T> extends ViewModel {
  T? get id;

  Stream<T?> get streamId;
}

abstract class ViewModel extends Disposable {
  late final _state = stateOf<PreloaderState>(PreloaderState.none);

  PreloaderState get state => _state.value;

  set state(PreloaderState newState) => _state.value = newState;

  Stream<PreloaderState> get stateStream => _state.distinct();

  Future<Either<BaseError, T>> loadOperation<T>(Future<Either<BaseError, T>> operation) {
    state = PreloaderState.loading;
    return operation.then<Either<BaseError, T>>((value) {
      if (!isDisposed) {
        if (value.isLeft()) {
          state = PreloaderState.error;
        } else {
          state = PreloaderState.success;
        }
      }
      return value;
    });
  }

  Future<Either<BaseError, Unit>> loadOperations(Iterable<Future<Either<BaseError, dynamic>>> operations) {
    state = PreloaderState.loading;
    return Future.wait(operations).then((result) {
      var value = right<BaseError, Unit>(unit);

      for (final element in result) {
        if (element.isLeft()) {
          value = element.map<Unit>((dynamic r) => unit);
          break;
        }
      }

      if (!isDisposed) {
        if (value.isLeft()) {
          state = PreloaderState.error;
        } else {
          state = PreloaderState.success;
        }
      }
      return value;
    });
  }
}

import 'package:vitals_core/src/model/error/exception.dart';
import 'package:vitals_utils/vitals_utils.dart';

const noExistException = ValueNotExistsException();

const emptyStorageException = EmptyStorageException();

extension EitherExt<L, R> on Either<L, R?> {
  Either<L, R> leftIfNull(L Function() fun) => mapNull(() => left(fun()));

  Either<L, R> mapNull(Either<L, R> Function() fun) => fold(
        (l) => left(l),
        (r) => r != null ? right(r) : fun(),
      );
}

extension NonNullEitherExt<L, R> on Either<L, R> {
  R? get valueOrNull => fold(
        (l) => null,
        (r) => r,
      );
}

extension EitherWithBaseErrorExt<R> on Either<BaseError, R?> {
  Either<BaseError, R> noExistIfNull() => leftIfNull(
        () => BaseError(
          message: noExistException.toString(),
          error: noExistException,
        ),
      );

  Either<BaseError, R> emptyStorageIfNull() => leftIfNull(
        () => BaseError(
          message: emptyStorageException.toString(),
          error: emptyStorageException,
        ),
      );
}

extension BaseErrorExt<R> on R? {
  Either<BaseError, R> noExistIfNull() => this != null
      ? right(this as R)
      : left(
          BaseError(
            message: noExistException.toString(),
            error: noExistException,
          ),
        );

  Either<BaseError, R> emptyStorageIfNull() => this != null
      ? right(this as R)
      : left(
          BaseError(
            message: emptyStorageException.toString(),
            error: emptyStorageException,
          ),
        );
}

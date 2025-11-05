class BaseError {
  final int? statusCode;
  final String? message;
  final dynamic data;
  final dynamic error;

  BaseError({this.statusCode, this.message, this.data, this.error});

  //ignore: only_throw_errors
  T reThrow<T>() => throw error as Object;
}

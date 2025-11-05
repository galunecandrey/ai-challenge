import 'package:dio/dio.dart';

typedef ResponseFactory = void Function(
  MockRequestInterceptorHandler handler,
);

typedef ResponseFactoryWithResult = bool Function(
  MockRequestInterceptorHandler handler,
);

abstract class MockInterceptor extends Interceptor {
  final _responses = <String, ResponseFactory?>{};
  final _requests = <RequestOptions>[];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _requests.add(options);

    final savedResponse = _responses[options.methodPath];
    _responses[options.methodPath] = null;

    if (savedResponse != null) {
      return savedResponse(MockRequestInterceptorHandler(options, handler));
    }

    if (predefinedResponses.containsKey(options.methodPath)) {
      return predefinedResponses[options.methodPath]!.call(MockRequestInterceptorHandler(options, handler));
    }

    if (defaultResponseFactory.call(MockRequestInterceptorHandler(options, handler))) {
      return;
    }

    return super.onRequest(options, handler);
  }

  ResponseFactoryWithResult get defaultResponseFactory => (handler) => false;

  void setResponse(String path, ResponseFactory response) {
    _responses[path] = response;
  }

  Map<String, ResponseFactory> get predefinedResponses;

  List<RequestOptions> get requests => [..._requests];
}

class MockRequestInterceptorHandler {
  MockRequestInterceptorHandler(
    this.options,
    this._handler,
  );

  final RequestOptions options;
  final RequestInterceptorHandler _handler;

  void next() => _handler.next(options);

  void resolve<T>({T? data}) => _handler.resolve(
        Response<T>(
          requestOptions: options,
          data: data,
        ),
        true,
      );

  void reject<T>({
    dynamic error,
    Response<T>? response,
    DioExceptionType type = DioExceptionType.unknown,
  }) =>
      _handler.reject(
        DioException(
          requestOptions: options,
          response: response,
          error: error,
        ),
        true,
      );
}

extension MockRequestOptionsExt on RequestOptions {
  String get methodPath => '$method$path';
}

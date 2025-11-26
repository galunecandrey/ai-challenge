import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart' show LazySingleton;

@LazySingleton(as: http.BaseClient)
class LoggingClient extends http.BaseClient {
  final http.Client _inner;

  LoggingClient() : _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 🔹 Лог запиту
    developer.log('➡️ [REQUEST] ${request.method} ${request.url}');
    developer.log('Headers: ${Map.fromEntries(
      request.headers.entries.where((e) => e.key.toLowerCase() != 'authorization'),
    )}');

    if (request is http.Request) {
      // Лог тіла запиту, якщо воно є
      if (request.body.isNotEmpty) {
        developer.log('Body: ${request.body}');
      }
    } else if (request is http.MultipartRequest) {
      developer.log('[Multipart request: fields=${request.fields}, files=${request.files}]');
    }

    final response = await _inner.send(request);

    // 🔹 Лог статусу перед читанням потоку
    developer.log('⬅️ [RESPONSE] ${response.statusCode}');

    // Читаємо тіло відповіді
    final responseBytes = await response.stream.toBytes();
    final bodyString = utf8.decode(responseBytes);

    developer.log('Response body: $bodyString');

    // Повертаємо новий StreamedResponse із зчитаним тілом
    return http.StreamedResponse(
      Stream.fromIterable([responseBytes]),
      response.statusCode,
      headers: response.headers,
      request: response.request,
      reasonPhrase: response.reasonPhrase,
    );
  }
}

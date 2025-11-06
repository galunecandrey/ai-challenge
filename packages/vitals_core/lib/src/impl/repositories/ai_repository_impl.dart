import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/api/repositories/ai_repository.dart' show AIRepository;
import 'package:vitals_core/src/impl/storages/messages_storage.dart' show MessagesStorage;
import 'package:vitals_core/src/model/message/message.dart';
import 'package:vitals_core/src/model/message/message_data.dart';
import 'package:vitals_core/src/utils/const/prompts.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: AIRepository)
final class AIRepositoryImpl implements AIRepository {
  AIRepositoryImpl(
    this._client,
    this._messagesStorage,
    this._operationService,
    this._dateTimeProvider,
  );

  final OpenAIClient _client;
  final OperationService _operationService;
  final MessagesStorage _messagesStorage;
  final DateTimeProvider _dateTimeProvider;

  @override
  Future<Either<BaseError, Unit>> sendText(String text) {
    _messagesStorage.set(
      List.unmodifiable([
        Message(
          id: _dateTimeProvider.current.millisecondsSinceEpoch,
          role: MessageRoles.user,
          text: text,
        ),
        ..._messagesStorage.get().getOrElse(() => List.unmodifiable([])),
      ]),
    );
    return _operationService
        .safeAsyncOp(
      () => _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: const ChatCompletionModel.modelId('gpt-5'),
          messages: [
            const ChatCompletionMessage.system(
              content: kSystemJSONSchemaPrompt,
            ),
            ..._messagesStorage.get().getOrElse(() => List.unmodifiable([])).map((m) => m.toChatCompletionMessage),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(text),
            ),
          ],
        ),
      ),
    )
        .then((result) {
      info(result.toString());
      result.forEach((r) {
        _messagesStorage.set(
          List.unmodifiable([
            r.choices.first.let(
              (it) => Message(
                id: _dateTimeProvider.current.millisecondsSinceEpoch,
                role: MessageRoles.assistant,
                text: it.message.content.orEmpty,
                data: _operationService
                    .safeSyncOp(
                      () => MessageData.fromJson(
                        jsonDecode(it.message.content.orEmpty) as Map<String, dynamic>,
                      ),
                    )
                    .fold(
                      (l) => null,
                      (r) => r,
                    ),
              ),
            ),
            ..._messagesStorage.get().getOrElse(() => List.unmodifiable([])),
          ]),
        );
      });
      return result.map((r) => unit);
    });
  }

  @override
  Either<BaseError, List<Message>> get history => _messagesStorage.get();

  @override
  Stream<Either<BaseError, List<Message>>> getHistoryStream({bool sendFirst = false}) =>
      _messagesStorage.stream(sendFirst: sendFirst);

  @override
  Either<BaseError, Unit> clearHistory() => _messagesStorage.clean();
}

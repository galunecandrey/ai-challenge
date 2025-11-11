import 'dart:convert';

import 'package:openai_dart/openai_dart.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/impl/storages/messages_storage.dart';
import 'package:vitals_core/src/model/enums/ai_agents_enum.dart';
import 'package:vitals_core/src/model/message/message.dart';
import 'package:vitals_core/src/model/message/message_data.dart';
import 'package:vitals_utils/vitals_utils.dart';

final class AIAgent {
  AIAgent(
    this._agent,
    this._client,
    this._messagesStorage,
    this._operationService,
    this._dateTimeProvider,
  );

  final AIAgents _agent;
  final OpenAIClient _client;
  final OperationService _operationService;
  final MessagesStorage _messagesStorage;
  final DateTimeProvider _dateTimeProvider;

  Future<Either<BaseError, Message>> sendRequest(String text) {
    _messagesStorage.set(
      _agent.key,
      List.unmodifiable([
        Message(
          id: _dateTimeProvider.current.millisecondsSinceEpoch,
          role: MessageRoles.user,
          text: text,
        ),
        ..._messagesStorage.get(_agent.key).getOrElse(() => List.unmodifiable([])),
      ]),
    );
    return _operationService
        .safeAsyncOp(
      () => _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(_agent.model),
          messages: [
            if (_agent.systemPrompt != null)
              ChatCompletionMessage.system(
                content: _agent.systemPrompt!,
              ),
            ..._messagesStorage
                .get(_agent.key)
                .getOrElse(() => List.unmodifiable([]))
                .map((m) => m.toChatCompletionMessage),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(text),
            ),
          ],
        ),
      ),
    )
        .then((result) {
      info(result.toString());

      return result.map((r) {
        final result = r.choices.first.let(
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
        );
        _messagesStorage.set(
          _agent.key,
          List.unmodifiable([
            result,
            ..._messagesStorage.get(_agent.key).getOrElse(() => List.unmodifiable([])),
          ]),
        );
        return result;
      });
    });
  }

  Either<BaseError, List<Message>> get context => _messagesStorage.get(_agent.key);

  Stream<Either<BaseError, List<Message>>> getContextStream({bool sendFirst = false}) =>
      _messagesStorage.streamKey(_agent.key, sendFirst: sendFirst);

  Either<BaseError, Unit> clearContext() => _messagesStorage.delete(_agent.key);
}

// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_dart/openai_dart.dart'
    show ChatCompletionDeveloperMessageContent, ChatCompletionMessage, ChatCompletionUserMessageContent;
import 'package:vitals_core/src/model/message/message_data.dart';

part 'message.freezed.dart';

@freezed
sealed class Message with _$Message {
  const factory Message({
    required int id,
    required MessageRoles role,
    required String text,
    MessageData? data,
  }) = _Message;
}

extension MessageExt on Message {
  ChatCompletionMessage get toChatCompletionMessage => switch (role) {
        MessageRoles.developer => ChatCompletionMessage.developer(
            content: ChatCompletionDeveloperMessageContent.text(text),
          ),
        MessageRoles.user => ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(text),
          ),
        MessageRoles.assistant => ChatCompletionMessage.assistant(
            content: text,
          ),
        MessageRoles.tool => ChatCompletionMessage.tool(content: text, toolCallId: ''),
        MessageRoles.system => ChatCompletionMessage.system(
            content: text,
          ),
        MessageRoles.function => ChatCompletionMessage.function(content: text, name: ''),
      };

  bool get isUser => role == MessageRoles.user;
}

enum MessageRoles {
  developer,
  user,
  assistant,
  tool,
  system,
  function,
}

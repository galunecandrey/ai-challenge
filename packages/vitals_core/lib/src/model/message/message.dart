// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openai_dart/openai_dart.dart'
    show ChatCompletionDeveloperMessageContent, ChatCompletionMessage, ChatCompletionUserMessageContent;
import 'package:vitals_core/src/model/entities/messages/message_entity.dart';
import 'package:vitals_core/src/model/message/usage_data.dart';

part 'message.freezed.dart';

@freezed
sealed class Message with _$Message {
  const factory Message({
    required String id,
    required MessageRoles role,
    required String text,
    required int unixTime,
    required String sessionKey,
    @Default(true) bool isActive,
    @Default(false) bool isCompressed,
    UsageData? usage,
  }) = _Message;
}

extension MessageExt on Message {
  MessageEntity get toEntity => MessageEntity(
        id,
        role.value,
        text,
        sessionKey,
        unixTime,
        isActive,
        isCompressed,
        usage: usage?.toEntity,
      );

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
  developer('developer'),
  user('user'),
  assistant('assistant'),
  tool('tool'),
  system('system'),
  function('function');

  final String value;

  const MessageRoles(this.value);
}

extension MessageRolesStringExt on String {
  MessageRoles get toMessageRole {
    switch (toLowerCase()) {
      case 'developer':
        return MessageRoles.developer;
      case 'user':
        return MessageRoles.user;
      case 'assistant':
        return MessageRoles.assistant;
      case 'tool':
        return MessageRoles.tool;
      case 'system':
        return MessageRoles.system;
      case 'function':
        return MessageRoles.function;
    }
    throw Exception('Such message role does not support: $this');
  }
}

import 'package:openai_dart/openai_dart.dart' show ChatCompletionMessage, ChatCompletionUserMessageContent;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart' show EmbeddingRecord;

String buildContextFromChunks(List<EmbeddingRecord> chunks) {
  final buffer = StringBuffer();

  for (final c in chunks) {
    buffer
      ..writeln('---')
      ..writeln('Source: ${c.documentId} [chunk ${c.chunkIndex}]')
      ..writeln(c.text.trim())
      ..writeln();
  }

  return buffer.toString();
}

List<ChatCompletionMessage> buildRagMessages({
  required String question,
  required String context,
}) =>
    [
      const ChatCompletionMessage.system(
        content: 'You are a helpful assistant. Use ONLY the provided context to answer. '
            'If the answer is not in the context, say you do not know.',
      ),
      ChatCompletionMessage.system(
        content: 'Context:\n$context',
      ),
      ChatCompletionMessage.user(
        content: ChatCompletionUserMessageContent.string(question),
      ),
    ];

List<ChatCompletionMessage> buildPlainMessages({
  required String question,
}) =>
    [
      const ChatCompletionMessage.system(
        content: 'You are a helpful assistant. Answer the user directly.',
      ),
      ChatCompletionMessage.user(
        content: ChatCompletionUserMessageContent.string(question),
      ),
    ];

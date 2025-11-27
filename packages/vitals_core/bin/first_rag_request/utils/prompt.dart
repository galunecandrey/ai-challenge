import 'package:openai_dart/openai_dart.dart' show ChatCompletionMessage, ChatCompletionUserMessageContent;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart' show EmbeddingRecord;

String buildContextFromChunks(List<EmbeddingRecord> chunks) {
  final buffer = StringBuffer()
    ..writeln('You are an AI assistant that answers ONLY based on the context chunks provided below.')
    ..writeln()
    ..writeln('REQUIREMENTS:')
    ..writeln('1. Your answer must be in pure Markdown.')
    ..writeln(
        '2. When using information from a chunk, you MUST cite it using its sourceId in square brackets, for example: [S1], [S3].')
    ..writeln('3. At the end of the answer you MUST add a section:')
    ..writeln('   ### Sources')
    ..writeln('   - [S1] <source title> (<url>)')
    ..writeln('   - [S3] <source title> (<url>)')
    ..writeln('4. If the answer cannot be derived from the provided chunks, say:')
    ..writeln('   "I cannot answer based on the provided sources."')
    ..writeln('5. Do NOT invent facts that are not present in the context.')
    ..writeln('6. Do NOT include any JSON in the answer.')
    ..writeln('7. Do NOT mention that you are citing sources — simply cite them.')
    ..writeln()
    ..writeln('ANSWER STRUCTURE (MANDATORY):')
    ..writeln('### Answer')
    ..writeln('<your Markdown answer with citations like [S1], [S2]>')
    ..writeln()
    ..writeln('### Sources')
    ..writeln('- [S1] Title (URL)')
    ..writeln('- [S2] Title (URL)')
    ..writeln()
    ..writeln('---')
    ..writeln('Below are the available context chunks. Each chunk has: sourceId, title, url, text.')
    ..writeln();

  for (final chunk in chunks) {
    buffer
      ..writeln('sourceId: ${chunk.chunkId}')
      ..writeln('title: ${chunk.documentId}')
      ..writeln('url: ${chunk.uri}')
      ..writeln('text: """')
      ..writeln(chunk.text)
      ..writeln('"""')
      ..writeln('---')
      ..writeln();
  }

  return buffer.toString();
}

List<ChatCompletionMessage> buildRagMessages({
  required String question,
  required String context,
}) =>
    [
      ChatCompletionMessage.system(
        content: context,
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

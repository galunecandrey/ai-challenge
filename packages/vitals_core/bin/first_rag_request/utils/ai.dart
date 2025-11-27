//ignore_for_file: avoid_print
import 'package:openai_dart/openai_dart.dart' show ChatCompletionModel, CreateChatCompletionRequest, OpenAIClient;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';

import '../utils/embed.dart';
import '../utils/prompt.dart';
import '../utils/utils.dart';

Future<void> compareRagAndNonRag({
  required OpenAIClient client,
  required List<EmbeddingRecord> records,
  required String question,
  int topK = 4,
  String chatModel = 'gpt-4.1-mini', // or any chat model you prefer
}) async {
  // 1) Embed the question
  final queryEmbedding = await embedQuestion(
    client: client,
    question: question,
    embeddingModel: records.first.model, // e.g. "text-embedding-3-small"
  );

  // 2) Retrieve relevant chunks
  final topChunks = topKRelevantChunks(
    records: records,
    queryEmbedding: queryEmbedding,
    topK: topK,
  );

  if (topChunks.isEmpty) {
    print('Index is empty or no chunks found. Cannot run RAG.');
    return;
  }

  final context = buildContextFromChunks(topChunks);

  // 3) Build messages
  final ragMessages = buildRagMessages(
    question: question,
    context: context,
  );

  final plainMessages = buildPlainMessages(
    question: question,
  );

  // 4) Call LLM WITH RAG (context)
  final ragRes = await client.createChatCompletion(
    request: CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(chatModel),
      messages: ragMessages, // deterministic for easier comparison
    ),
  );

  final ragAnswer = ragRes.choices.first.message.content ?? '';

  // 5) Call LLM WITHOUT RAG (no context)
  final plainRes = await client.createChatCompletion(
    request: CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(chatModel),
      messages: plainMessages,
    ),
  );

  final plainAnswer = plainRes.choices.first.message.content ?? '';

  // 6) Print comparison
  print('==================== QUESTION ====================');
  print(question);
  print('\n==================== RAG ANSWER ===================');
  print(ragAnswer);
  print('\n==================== NO-RAG ANSWER ================');
  print(plainAnswer);
  print('\n==================== USED CONTEXT =================');
  print(context);
}

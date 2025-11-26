import 'package:openai_dart/openai_dart.dart';

import '../data/models.dart';
import '../utils/embed_chunks.dart';
import '../utils/utils.dart';

/// Build embeddings index from a map of {documentId: fullText}
Future<EmbeddingIndex> buildIndexFromDocuments(
  Map<String, String> docs, {
  required String apiKey,
  int maxTokens = 256,
  int overlapTokens = 50,
  String model = 'text-embedding-3-small',
}) async {
  final client = OpenAIClient(apiKey: apiKey);

  // 1. Chunk all documents
  final allChunks = <DocumentChunk>[];
  docs.forEach((docId, text) {
    final chunks = chunkDocument(documentId: docId, text: text, maxTokens: maxTokens, overlapTokens: overlapTokens);
    allChunks.addAll(chunks);
  });

  // 2. Get embeddings
  final records = await embedChunks(client: client, chunks: allChunks, model: model);

  // 3. Build index object
  final index = EmbeddingIndex(model: model, records: records);

  // Close client if needed
  client.endSession();

  return index;
}

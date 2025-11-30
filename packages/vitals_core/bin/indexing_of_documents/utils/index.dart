import 'package:openai_dart/openai_dart.dart';
import 'package:vitals_core/src/model/embedding/chunk/document_chunk.dart' show DocumentChunk;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';

import '../utils/embed_chunks.dart';
import '../utils/utils.dart';

/// Build embeddings embedding from a map of {documentId: fullText}
Future<List<EmbeddingRecord>> buildIndexFromDocuments(
  Map<String, ({String text, String uri})> docs, {
  required String apiKey,
  int maxTokens = 256,
  int overlapTokens = 50,
  String model = 'text-embedding-3-small',
}) async {
  final client = OpenAIClient(apiKey: apiKey);

  // 1. Chunk all documents
  final allChunks = <DocumentChunk>[];
  docs.forEach((docId, doc) {
    final chunks = chunkDocument(
      documentId: docId,
      text: doc.text,
      uri: doc.uri,
      maxTokens: maxTokens,
      overlapTokens: overlapTokens,
    );
    allChunks.addAll(chunks);
  });

  // 2. Get embeddings
  final records = await embedChunks(client: client, chunks: allChunks, model: model);

  // Close client if needed
  client.endSession();

  return records;
}

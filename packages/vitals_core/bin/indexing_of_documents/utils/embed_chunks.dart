import 'package:collection/collection.dart';
import 'package:openai_dart/openai_dart.dart' show CreateEmbeddingRequest, EmbeddingInput, EmbeddingModel, OpenAIClient;

import '../data/models.dart';

/// Get embeddings for a list of chunks. Batches to avoid payload limits.
Future<List<EmbeddingRecord>> embedChunks({
  required OpenAIClient client,
  required List<DocumentChunk> chunks,
  String model = 'text-embedding-3-small',
  int batchSize = 64,
}) async {
  final records = <EmbeddingRecord>[];

  for (final batch in chunks.slices(batchSize)) {
    final texts = batch.map((c) => c.text).toList();

    final response = await client.createEmbedding(
      request: CreateEmbeddingRequest(
        model: EmbeddingModel.modelId(model),
        input: EmbeddingInput.listString(texts),
      ),
    );

    if (response.data.length != batch.length) {
      throw StateError('Embeddings count mismatch: got ${response.data.length}, expected ${batch.length}');
    }

    for (var i = 0; i < batch.length; i++) {
      final chunk = batch[i];
      final emb = response.data[i].embedding;

      records.add(
        EmbeddingRecord(
          chunkId: chunk.id,
          embedding: emb.map(
            vector: (v) => v.value,
            vectorBase64: (vectorBase64) => throw StateError("Embeddings can't be vectorBase64"),
          ),
          documentId: chunk.documentId,
          chunkIndex: chunk.chunkIndex,
          text: chunk.text,
        ),
      );
    }
  }

  return records;
}

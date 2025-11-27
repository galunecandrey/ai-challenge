import 'package:collection/collection.dart';
import 'package:openai_dart/openai_dart.dart'
    show CreateEmbeddingRequest, EmbeddingInput, EmbeddingModel, EmbeddingX, OpenAIClient;
import 'package:vitals_core/src/model/embedding/chunk/document_chunk.dart' show DocumentChunk;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart' show EmbeddingRecord;

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
      final emb = response.data[i].embeddingVector;

      records.add(
        EmbeddingRecord(
          chunkId: chunk.id,
          embedding: emb,
          documentId: chunk.documentId,
          chunkIndex: chunk.chunkIndex,
          text: chunk.text,
          model: model,
          uri: chunk.uri,
        ),
      );
    }
  }

  return records;
}

import 'dart:math' as math show sqrt;

import 'package:vitals_core/src/model/embedding/record/embedding_record.dart' show EmbeddingRecord;

double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length) {
    throw ArgumentError('Vectors must have same length');
  }
  double dot = 0;
  double normA = 0;
  double normB = 0;

  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }

  if (normA == 0 || normB == 0) {
    return 0;
  }
  return dot / (math.sqrt(normA) * math.sqrt(normB));
}

List<EmbeddingRecord> topKRelevantChunks({
  required List<EmbeddingRecord> records,
  required List<double> queryEmbedding,
  int topK = 4,
}) {
  final scored = <(EmbeddingRecord, double)>[];

  for (final rec in records) {
    final score = cosineSimilarity(queryEmbedding, rec.embedding);
    scored.add((rec, score));
  }

  scored.sort((a, b) => b.$2.compareTo(a.$2)); // descending by score

  return scored.take(topK).map((e) => e.$1).toList();
}

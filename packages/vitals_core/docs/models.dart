/// A piece of a document after chunking.
class DocumentChunk {
  final String id; // unique within corpus
  final String documentId; // original doc id (e.g. filename)
  final int chunkIndex; // sequential number
  final String text;

  DocumentChunk({
    required this.id,
    required this.documentId,
    required this.chunkIndex,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'documentId': documentId,
        'chunkIndex': chunkIndex,
        'text': text,
      };
}

/// One embedding row in the embedding.
class EmbeddingRecord {
  final String chunkId;
  final List<double> embedding;
  final String documentId;
  final int chunkIndex;
  final String text;

  EmbeddingRecord({
    required this.chunkId,
    required this.embedding,
    required this.documentId,
    required this.chunkIndex,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
        'chunkId': chunkId,
        'embedding': embedding,
        'documentId': documentId,
        'chunkIndex': chunkIndex,
        'text': text,
      };
}

/// The whole embedding saved to disk.
class EmbeddingIndex {
  final String model;
  final List<EmbeddingRecord> records;

  EmbeddingIndex({
    required this.model,
    required this.records,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'records': records.map((r) => r.toJson()).toList(),
      };
}

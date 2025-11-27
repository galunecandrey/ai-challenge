import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitals_core/src/model/entities/embedding/embedding_entity.dart' show EmbeddingEntity;

part 'embedding_record.freezed.dart';

part 'embedding_record.g.dart';

@freezed
sealed class EmbeddingRecord with _$EmbeddingRecord {
  const factory EmbeddingRecord({
    required String chunkId,
    required List<double> embedding,
    required String documentId,
    required int chunkIndex,
    required String text,
    required String model,
    required String uri,
  }) = _EmbeddingRecord;

  factory EmbeddingRecord.fromJson(Map<String, dynamic> json) => _$EmbeddingRecordFromJson(json);
}

extension EmbeddingRecordExt on EmbeddingRecord {
  EmbeddingEntity get toEntity => EmbeddingEntity(
        chunkId,
        documentId,
        chunkIndex,
        text,
        model,
        uri,
        embedding: embedding,
      );
}

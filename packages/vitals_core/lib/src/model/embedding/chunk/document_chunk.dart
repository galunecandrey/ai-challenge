import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_chunk.freezed.dart';

part 'document_chunk.g.dart';

@freezed
sealed class DocumentChunk with _$DocumentChunk {
  const factory DocumentChunk({
    required String id, // unique within corpus
    required String documentId, // original doc id (e.g. filename)
    required int chunkIndex, // sequential number
    required String text,
    required String uri,
  }) = _DocumentChunk;

  factory DocumentChunk.fromJson(Map<String, dynamic> json) => _$DocumentChunkFromJson(json);
}

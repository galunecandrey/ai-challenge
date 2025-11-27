// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedding_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmbeddingRecordImpl _$$EmbeddingRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$EmbeddingRecordImpl(
      chunkId: json['chunkId'] as String,
      embedding: (json['embedding'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      documentId: json['documentId'] as String,
      chunkIndex: (json['chunkIndex'] as num).toInt(),
      text: json['text'] as String,
      model: json['model'] as String,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$$EmbeddingRecordImplToJson(
        _$EmbeddingRecordImpl instance) =>
    <String, dynamic>{
      'chunkId': instance.chunkId,
      'embedding': instance.embedding,
      'documentId': instance.documentId,
      'chunkIndex': instance.chunkIndex,
      'text': instance.text,
      'model': instance.model,
      'uri': instance.uri,
    };

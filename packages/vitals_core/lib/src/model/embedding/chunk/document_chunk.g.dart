// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_chunk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DocumentChunkImpl _$$DocumentChunkImplFromJson(Map<String, dynamic> json) =>
    _$DocumentChunkImpl(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      chunkIndex: (json['chunkIndex'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$$DocumentChunkImplToJson(_$DocumentChunkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'chunkIndex': instance.chunkIndex,
      'text': instance.text,
    };

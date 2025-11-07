// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageDataImpl _$$MessageDataImplFromJson(Map<String, dynamic> json) =>
    _$MessageDataImpl(
      tag: json['tag'] as String,
      title: json['title'] as String,
      answer: json['answer'] as String,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$MessageDataImplToJson(_$MessageDataImpl instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'title': instance.title,
      'answer': instance.answer,
      'time': instance.time.toIso8601String(),
    };

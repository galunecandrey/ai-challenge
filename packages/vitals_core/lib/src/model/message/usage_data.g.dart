// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsageDataImpl _$$UsageDataImplFromJson(Map<String, dynamic> json) =>
    _$UsageDataImpl(
      requestTokens: (json['requestTokens'] as num?)?.toInt(),
      responseTokens: (json['responseTokens'] as num?)?.toInt(),
      totalTokens: (json['totalTokens'] as num?)?.toInt(),
      time: json['time'] == null
          ? null
          : Duration(microseconds: (json['time'] as num).toInt()),
    );

Map<String, dynamic> _$$UsageDataImplToJson(_$UsageDataImpl instance) =>
    <String, dynamic>{
      'requestTokens': instance.requestTokens,
      'responseTokens': instance.responseTokens,
      'totalTokens': instance.totalTokens,
      'time': instance.time?.inMicroseconds,
    };

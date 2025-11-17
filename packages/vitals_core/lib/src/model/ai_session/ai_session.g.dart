// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AISessionAdapter extends TypeAdapter<_$AISessionImpl> {
  @override
  final int typeId = 1;

  @override
  _$AISessionImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$AISessionImpl(
      key: fields[0] as String,
      name: fields[1] as String?,
      systemPrompt: fields[2] as String?,
      model: fields[3] == null ? 'gpt-5' : fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$AISessionImpl obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.systemPrompt)
      ..writeByte(3)
      ..write(obj.model);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AISessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AISessionImpl _$$AISessionImplFromJson(Map<String, dynamic> json) =>
    _$AISessionImpl(
      key: json['key'] as String,
      name: json['name'] as String?,
      systemPrompt: json['systemPrompt'] as String?,
      model: json['model'] as String? ?? 'gpt-5',
    );

Map<String, dynamic> _$$AISessionImplToJson(_$AISessionImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'systemPrompt': instance.systemPrompt,
      'model': instance.model,
    };

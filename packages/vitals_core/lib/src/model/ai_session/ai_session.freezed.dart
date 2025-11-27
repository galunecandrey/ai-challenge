// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AISession _$AISessionFromJson(Map<String, dynamic> json) {
  return _AISession.fromJson(json);
}

/// @nodoc
mixin _$AISession {
  @HiveField(0)
  String get key => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get systemPrompt => throw _privateConstructorUsedError;
  @HiveField(3, defaultValue: 'gpt-5')
  String get model => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AISessionCopyWith<AISession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AISessionCopyWith<$Res> {
  factory $AISessionCopyWith(AISession value, $Res Function(AISession) then) =
      _$AISessionCopyWithImpl<$Res, AISession>;
  @useResult
  $Res call(
      {@HiveField(0) String key,
      @HiveField(1) String? name,
      @HiveField(2) String? systemPrompt,
      @HiveField(3, defaultValue: 'gpt-5') String model});
}

/// @nodoc
class _$AISessionCopyWithImpl<$Res, $Val extends AISession>
    implements $AISessionCopyWith<$Res> {
  _$AISessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = freezed,
    Object? systemPrompt = freezed,
    Object? model = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      systemPrompt: freezed == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AISessionImplCopyWith<$Res>
    implements $AISessionCopyWith<$Res> {
  factory _$$AISessionImplCopyWith(
          _$AISessionImpl value, $Res Function(_$AISessionImpl) then) =
      __$$AISessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String key,
      @HiveField(1) String? name,
      @HiveField(2) String? systemPrompt,
      @HiveField(3, defaultValue: 'gpt-5') String model});
}

/// @nodoc
class __$$AISessionImplCopyWithImpl<$Res>
    extends _$AISessionCopyWithImpl<$Res, _$AISessionImpl>
    implements _$$AISessionImplCopyWith<$Res> {
  __$$AISessionImplCopyWithImpl(
      _$AISessionImpl _value, $Res Function(_$AISessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = freezed,
    Object? systemPrompt = freezed,
    Object? model = null,
  }) {
    return _then(_$AISessionImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      systemPrompt: freezed == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: HiveEntities.kSessions, adapterName: 'AISessionAdapter')
class _$AISessionImpl implements _AISession {
  const _$AISessionImpl(
      {@HiveField(0) required this.key,
      @HiveField(1) this.name,
      @HiveField(2) this.systemPrompt,
      @HiveField(3, defaultValue: 'gpt-5') this.model = 'gpt-5'});

  factory _$AISessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AISessionImplFromJson(json);

  @override
  @HiveField(0)
  final String key;
  @override
  @HiveField(1)
  final String? name;
  @override
  @HiveField(2)
  final String? systemPrompt;
  @override
  @JsonKey()
  @HiveField(3, defaultValue: 'gpt-5')
  final String model;

  @override
  String toString() {
    return 'AISession(key: $key, name: $name, systemPrompt: $systemPrompt, model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AISessionImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.model, model) || other.model == model));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, name, systemPrompt, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AISessionImplCopyWith<_$AISessionImpl> get copyWith =>
      __$$AISessionImplCopyWithImpl<_$AISessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AISessionImplToJson(
      this,
    );
  }
}

abstract class _AISession implements AISession {
  const factory _AISession(
          {@HiveField(0) required final String key,
          @HiveField(1) final String? name,
          @HiveField(2) final String? systemPrompt,
          @HiveField(3, defaultValue: 'gpt-5') final String model}) =
      _$AISessionImpl;

  factory _AISession.fromJson(Map<String, dynamic> json) =
      _$AISessionImpl.fromJson;

  @override
  @HiveField(0)
  String get key;
  @override
  @HiveField(1)
  String? get name;
  @override
  @HiveField(2)
  String? get systemPrompt;
  @override
  @HiveField(3, defaultValue: 'gpt-5')
  String get model;
  @override
  @JsonKey(ignore: true)
  _$$AISessionImplCopyWith<_$AISessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

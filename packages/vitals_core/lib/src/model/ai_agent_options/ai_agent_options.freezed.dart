// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_agent_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AIAgentOptions {
  String get key => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get systemPrompt => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AIAgentOptionsCopyWith<AIAgentOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIAgentOptionsCopyWith<$Res> {
  factory $AIAgentOptionsCopyWith(
          AIAgentOptions value, $Res Function(AIAgentOptions) then) =
      _$AIAgentOptionsCopyWithImpl<$Res, AIAgentOptions>;
  @useResult
  $Res call({String key, String? name, String? systemPrompt, String model});
}

/// @nodoc
class _$AIAgentOptionsCopyWithImpl<$Res, $Val extends AIAgentOptions>
    implements $AIAgentOptionsCopyWith<$Res> {
  _$AIAgentOptionsCopyWithImpl(this._value, this._then);

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
abstract class _$$AIAgentOptionsImplCopyWith<$Res>
    implements $AIAgentOptionsCopyWith<$Res> {
  factory _$$AIAgentOptionsImplCopyWith(_$AIAgentOptionsImpl value,
          $Res Function(_$AIAgentOptionsImpl) then) =
      __$$AIAgentOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String? name, String? systemPrompt, String model});
}

/// @nodoc
class __$$AIAgentOptionsImplCopyWithImpl<$Res>
    extends _$AIAgentOptionsCopyWithImpl<$Res, _$AIAgentOptionsImpl>
    implements _$$AIAgentOptionsImplCopyWith<$Res> {
  __$$AIAgentOptionsImplCopyWithImpl(
      _$AIAgentOptionsImpl _value, $Res Function(_$AIAgentOptionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? name = freezed,
    Object? systemPrompt = freezed,
    Object? model = null,
  }) {
    return _then(_$AIAgentOptionsImpl(
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

class _$AIAgentOptionsImpl implements _AIAgentOptions {
  const _$AIAgentOptionsImpl(
      {required this.key,
      this.name,
      this.systemPrompt,
      this.model = 'gpt-4.1'});

  @override
  final String key;
  @override
  final String? name;
  @override
  final String? systemPrompt;
  @override
  @JsonKey()
  final String model;

  @override
  String toString() {
    return 'AIAgentOptions(key: $key, name: $name, systemPrompt: $systemPrompt, model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIAgentOptionsImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.model, model) || other.model == model));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, name, systemPrompt, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AIAgentOptionsImplCopyWith<_$AIAgentOptionsImpl> get copyWith =>
      __$$AIAgentOptionsImplCopyWithImpl<_$AIAgentOptionsImpl>(
          this, _$identity);
}

abstract class _AIAgentOptions implements AIAgentOptions {
  const factory _AIAgentOptions(
      {required final String key,
      final String? name,
      final String? systemPrompt,
      final String model}) = _$AIAgentOptionsImpl;

  @override
  String get key;
  @override
  String? get name;
  @override
  String? get systemPrompt;
  @override
  String get model;
  @override
  @JsonKey(ignore: true)
  _$$AIAgentOptionsImplCopyWith<_$AIAgentOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'init_ai_agent_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InitAIAgentOptions {
  String get baseUrl => throw _privateConstructorUsedError;
  String get apikey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InitAIAgentOptionsCopyWith<InitAIAgentOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitAIAgentOptionsCopyWith<$Res> {
  factory $InitAIAgentOptionsCopyWith(
          InitAIAgentOptions value, $Res Function(InitAIAgentOptions) then) =
      _$InitAIAgentOptionsCopyWithImpl<$Res, InitAIAgentOptions>;
  @useResult
  $Res call({String baseUrl, String apikey});
}

/// @nodoc
class _$InitAIAgentOptionsCopyWithImpl<$Res, $Val extends InitAIAgentOptions>
    implements $InitAIAgentOptionsCopyWith<$Res> {
  _$InitAIAgentOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? apikey = null,
  }) {
    return _then(_value.copyWith(
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      apikey: null == apikey
          ? _value.apikey
          : apikey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitAIAgentOptionsImplCopyWith<$Res>
    implements $InitAIAgentOptionsCopyWith<$Res> {
  factory _$$InitAIAgentOptionsImplCopyWith(_$InitAIAgentOptionsImpl value,
          $Res Function(_$InitAIAgentOptionsImpl) then) =
      __$$InitAIAgentOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String baseUrl, String apikey});
}

/// @nodoc
class __$$InitAIAgentOptionsImplCopyWithImpl<$Res>
    extends _$InitAIAgentOptionsCopyWithImpl<$Res, _$InitAIAgentOptionsImpl>
    implements _$$InitAIAgentOptionsImplCopyWith<$Res> {
  __$$InitAIAgentOptionsImplCopyWithImpl(_$InitAIAgentOptionsImpl _value,
      $Res Function(_$InitAIAgentOptionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? apikey = null,
  }) {
    return _then(_$InitAIAgentOptionsImpl(
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      apikey: null == apikey
          ? _value.apikey
          : apikey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InitAIAgentOptionsImpl implements _InitAIAgentOptions {
  const _$InitAIAgentOptionsImpl({required this.baseUrl, required this.apikey});

  @override
  final String baseUrl;
  @override
  final String apikey;

  @override
  String toString() {
    return 'InitAIAgentOptions(baseUrl: $baseUrl, apikey: $apikey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitAIAgentOptionsImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.apikey, apikey) || other.apikey == apikey));
  }

  @override
  int get hashCode => Object.hash(runtimeType, baseUrl, apikey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InitAIAgentOptionsImplCopyWith<_$InitAIAgentOptionsImpl> get copyWith =>
      __$$InitAIAgentOptionsImplCopyWithImpl<_$InitAIAgentOptionsImpl>(
          this, _$identity);
}

abstract class _InitAIAgentOptions implements InitAIAgentOptions {
  const factory _InitAIAgentOptions(
      {required final String baseUrl,
      required final String apikey}) = _$InitAIAgentOptionsImpl;

  @override
  String get baseUrl;
  @override
  String get apikey;
  @override
  @JsonKey(ignore: true)
  _$$InitAIAgentOptionsImplCopyWith<_$InitAIAgentOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

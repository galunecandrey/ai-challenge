// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UsageData _$UsageDataFromJson(Map<String, dynamic> json) {
  return _UsageData.fromJson(json);
}

/// @nodoc
mixin _$UsageData {
  int? get requestTokens => throw _privateConstructorUsedError;
  int? get responseTokens => throw _privateConstructorUsedError;
  int? get totalTokens => throw _privateConstructorUsedError;
  Duration? get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsageDataCopyWith<UsageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageDataCopyWith<$Res> {
  factory $UsageDataCopyWith(UsageData value, $Res Function(UsageData) then) =
      _$UsageDataCopyWithImpl<$Res, UsageData>;
  @useResult
  $Res call(
      {int? requestTokens,
      int? responseTokens,
      int? totalTokens,
      Duration? time});
}

/// @nodoc
class _$UsageDataCopyWithImpl<$Res, $Val extends UsageData>
    implements $UsageDataCopyWith<$Res> {
  _$UsageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestTokens = freezed,
    Object? responseTokens = freezed,
    Object? totalTokens = freezed,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      requestTokens: freezed == requestTokens
          ? _value.requestTokens
          : requestTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      responseTokens: freezed == responseTokens
          ? _value.responseTokens
          : responseTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTokens: freezed == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsageDataImplCopyWith<$Res>
    implements $UsageDataCopyWith<$Res> {
  factory _$$UsageDataImplCopyWith(
          _$UsageDataImpl value, $Res Function(_$UsageDataImpl) then) =
      __$$UsageDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? requestTokens,
      int? responseTokens,
      int? totalTokens,
      Duration? time});
}

/// @nodoc
class __$$UsageDataImplCopyWithImpl<$Res>
    extends _$UsageDataCopyWithImpl<$Res, _$UsageDataImpl>
    implements _$$UsageDataImplCopyWith<$Res> {
  __$$UsageDataImplCopyWithImpl(
      _$UsageDataImpl _value, $Res Function(_$UsageDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestTokens = freezed,
    Object? responseTokens = freezed,
    Object? totalTokens = freezed,
    Object? time = freezed,
  }) {
    return _then(_$UsageDataImpl(
      requestTokens: freezed == requestTokens
          ? _value.requestTokens
          : requestTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      responseTokens: freezed == responseTokens
          ? _value.responseTokens
          : responseTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTokens: freezed == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UsageDataImpl implements _UsageData {
  const _$UsageDataImpl(
      {this.requestTokens, this.responseTokens, this.totalTokens, this.time});

  factory _$UsageDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageDataImplFromJson(json);

  @override
  final int? requestTokens;
  @override
  final int? responseTokens;
  @override
  final int? totalTokens;
  @override
  final Duration? time;

  @override
  String toString() {
    return 'UsageData(requestTokens: $requestTokens, responseTokens: $responseTokens, totalTokens: $totalTokens, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageDataImpl &&
            (identical(other.requestTokens, requestTokens) ||
                other.requestTokens == requestTokens) &&
            (identical(other.responseTokens, responseTokens) ||
                other.responseTokens == responseTokens) &&
            (identical(other.totalTokens, totalTokens) ||
                other.totalTokens == totalTokens) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, requestTokens, responseTokens, totalTokens, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageDataImplCopyWith<_$UsageDataImpl> get copyWith =>
      __$$UsageDataImplCopyWithImpl<_$UsageDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageDataImplToJson(
      this,
    );
  }
}

abstract class _UsageData implements UsageData {
  const factory _UsageData(
      {final int? requestTokens,
      final int? responseTokens,
      final int? totalTokens,
      final Duration? time}) = _$UsageDataImpl;

  factory _UsageData.fromJson(Map<String, dynamic> json) =
      _$UsageDataImpl.fromJson;

  @override
  int? get requestTokens;
  @override
  int? get responseTokens;
  @override
  int? get totalTokens;
  @override
  Duration? get time;
  @override
  @JsonKey(ignore: true)
  _$$UsageDataImplCopyWith<_$UsageDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

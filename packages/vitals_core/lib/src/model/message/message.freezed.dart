// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  MessageRoles get role => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get unixTime => throw _privateConstructorUsedError;
  String get sessionKey => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isCompressed => throw _privateConstructorUsedError;
  UsageData? get usage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      MessageRoles role,
      String text,
      int unixTime,
      String sessionKey,
      bool isActive,
      bool isCompressed,
      UsageData? usage});

  $UsageDataCopyWith<$Res>? get usage;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
    Object? unixTime = null,
    Object? sessionKey = null,
    Object? isActive = null,
    Object? isCompressed = null,
    Object? usage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRoles,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      unixTime: null == unixTime
          ? _value.unixTime
          : unixTime // ignore: cast_nullable_to_non_nullable
              as int,
      sessionKey: null == sessionKey
          ? _value.sessionKey
          : sessionKey // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompressed: null == isCompressed
          ? _value.isCompressed
          : isCompressed // ignore: cast_nullable_to_non_nullable
              as bool,
      usage: freezed == usage
          ? _value.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as UsageData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UsageDataCopyWith<$Res>? get usage {
    if (_value.usage == null) {
      return null;
    }

    return $UsageDataCopyWith<$Res>(_value.usage!, (value) {
      return _then(_value.copyWith(usage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MessageRoles role,
      String text,
      int unixTime,
      String sessionKey,
      bool isActive,
      bool isCompressed,
      UsageData? usage});

  @override
  $UsageDataCopyWith<$Res>? get usage;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
    Object? unixTime = null,
    Object? sessionKey = null,
    Object? isActive = null,
    Object? isCompressed = null,
    Object? usage = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRoles,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      unixTime: null == unixTime
          ? _value.unixTime
          : unixTime // ignore: cast_nullable_to_non_nullable
              as int,
      sessionKey: null == sessionKey
          ? _value.sessionKey
          : sessionKey // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompressed: null == isCompressed
          ? _value.isCompressed
          : isCompressed // ignore: cast_nullable_to_non_nullable
              as bool,
      usage: freezed == usage
          ? _value.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as UsageData?,
    ));
  }
}

/// @nodoc

class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.role,
      required this.text,
      required this.unixTime,
      required this.sessionKey,
      this.isActive = true,
      this.isCompressed = false,
      this.usage});

  @override
  final String id;
  @override
  final MessageRoles role;
  @override
  final String text;
  @override
  final int unixTime;
  @override
  final String sessionKey;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isCompressed;
  @override
  final UsageData? usage;

  @override
  String toString() {
    return 'Message(id: $id, role: $role, text: $text, unixTime: $unixTime, sessionKey: $sessionKey, isActive: $isActive, isCompressed: $isCompressed, usage: $usage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.unixTime, unixTime) ||
                other.unixTime == unixTime) &&
            (identical(other.sessionKey, sessionKey) ||
                other.sessionKey == sessionKey) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isCompressed, isCompressed) ||
                other.isCompressed == isCompressed) &&
            (identical(other.usage, usage) || other.usage == usage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, role, text, unixTime,
      sessionKey, isActive, isCompressed, usage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final MessageRoles role,
      required final String text,
      required final int unixTime,
      required final String sessionKey,
      final bool isActive,
      final bool isCompressed,
      final UsageData? usage}) = _$MessageImpl;

  @override
  String get id;
  @override
  MessageRoles get role;
  @override
  String get text;
  @override
  int get unixTime;
  @override
  String get sessionKey;
  @override
  bool get isActive;
  @override
  bool get isCompressed;
  @override
  UsageData? get usage;
  @override
  @JsonKey(ignore: true)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

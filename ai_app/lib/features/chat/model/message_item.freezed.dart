// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MessageListItemModel {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function(Message model) item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function(Message model)? item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function(Message model)? item,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageWaiting value) waiting,
    required TResult Function(MessageItem value) item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageWaiting value)? waiting,
    TResult? Function(MessageItem value)? item,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageWaiting value)? waiting,
    TResult Function(MessageItem value)? item,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageListItemModelCopyWith<$Res> {
  factory $MessageListItemModelCopyWith(MessageListItemModel value,
          $Res Function(MessageListItemModel) then) =
      _$MessageListItemModelCopyWithImpl<$Res, MessageListItemModel>;
}

/// @nodoc
class _$MessageListItemModelCopyWithImpl<$Res,
        $Val extends MessageListItemModel>
    implements $MessageListItemModelCopyWith<$Res> {
  _$MessageListItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$MessageWaitingImplCopyWith<$Res> {
  factory _$$MessageWaitingImplCopyWith(_$MessageWaitingImpl value,
          $Res Function(_$MessageWaitingImpl) then) =
      __$$MessageWaitingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageWaitingImplCopyWithImpl<$Res>
    extends _$MessageListItemModelCopyWithImpl<$Res, _$MessageWaitingImpl>
    implements _$$MessageWaitingImplCopyWith<$Res> {
  __$$MessageWaitingImplCopyWithImpl(
      _$MessageWaitingImpl _value, $Res Function(_$MessageWaitingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$MessageWaitingImpl implements MessageWaiting {
  const _$MessageWaitingImpl();

  @override
  String toString() {
    return 'MessageListItemModel.waiting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MessageWaitingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function(Message model) item,
  }) {
    return waiting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function(Message model)? item,
  }) {
    return waiting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function(Message model)? item,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageWaiting value) waiting,
    required TResult Function(MessageItem value) item,
  }) {
    return waiting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageWaiting value)? waiting,
    TResult? Function(MessageItem value)? item,
  }) {
    return waiting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageWaiting value)? waiting,
    TResult Function(MessageItem value)? item,
    required TResult orElse(),
  }) {
    if (waiting != null) {
      return waiting(this);
    }
    return orElse();
  }
}

abstract class MessageWaiting implements MessageListItemModel {
  const factory MessageWaiting() = _$MessageWaitingImpl;
}

/// @nodoc
abstract class _$$MessageItemImplCopyWith<$Res> {
  factory _$$MessageItemImplCopyWith(
          _$MessageItemImpl value, $Res Function(_$MessageItemImpl) then) =
      __$$MessageItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Message model});

  $MessageCopyWith<$Res> get model;
}

/// @nodoc
class __$$MessageItemImplCopyWithImpl<$Res>
    extends _$MessageListItemModelCopyWithImpl<$Res, _$MessageItemImpl>
    implements _$$MessageItemImplCopyWith<$Res> {
  __$$MessageItemImplCopyWithImpl(
      _$MessageItemImpl _value, $Res Function(_$MessageItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
  }) {
    return _then(_$MessageItemImpl(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as Message,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageCopyWith<$Res> get model {
    return $MessageCopyWith<$Res>(_value.model, (value) {
      return _then(_value.copyWith(model: value));
    });
  }
}

/// @nodoc

class _$MessageItemImpl implements MessageItem {
  const _$MessageItemImpl({required this.model});

  @override
  final Message model;

  @override
  String toString() {
    return 'MessageListItemModel.item(model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageItemImpl &&
            (identical(other.model, model) || other.model == model));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageItemImplCopyWith<_$MessageItemImpl> get copyWith =>
      __$$MessageItemImplCopyWithImpl<_$MessageItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() waiting,
    required TResult Function(Message model) item,
  }) {
    return item(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? waiting,
    TResult? Function(Message model)? item,
  }) {
    return item?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? waiting,
    TResult Function(Message model)? item,
    required TResult orElse(),
  }) {
    if (item != null) {
      return item(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageWaiting value) waiting,
    required TResult Function(MessageItem value) item,
  }) {
    return item(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageWaiting value)? waiting,
    TResult? Function(MessageItem value)? item,
  }) {
    return item?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageWaiting value)? waiting,
    TResult Function(MessageItem value)? item,
    required TResult orElse(),
  }) {
    if (item != null) {
      return item(this);
    }
    return orElse();
  }
}

abstract class MessageItem implements MessageListItemModel {
  const factory MessageItem({required final Message model}) = _$MessageItemImpl;

  Message get model;
  @JsonKey(ignore: true)
  _$$MessageItemImplCopyWith<_$MessageItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_chunk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DocumentChunk _$DocumentChunkFromJson(Map<String, dynamic> json) {
  return _DocumentChunk.fromJson(json);
}

/// @nodoc
mixin _$DocumentChunk {
  String get id => throw _privateConstructorUsedError; // unique within corpus
  String get documentId =>
      throw _privateConstructorUsedError; // original doc id (e.g. filename)
  int get chunkIndex => throw _privateConstructorUsedError; // sequential number
  String get text => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentChunkCopyWith<DocumentChunk> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentChunkCopyWith<$Res> {
  factory $DocumentChunkCopyWith(
          DocumentChunk value, $Res Function(DocumentChunk) then) =
      _$DocumentChunkCopyWithImpl<$Res, DocumentChunk>;
  @useResult
  $Res call(
      {String id, String documentId, int chunkIndex, String text, String uri});
}

/// @nodoc
class _$DocumentChunkCopyWithImpl<$Res, $Val extends DocumentChunk>
    implements $DocumentChunkCopyWith<$Res> {
  _$DocumentChunkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? chunkIndex = null,
    Object? text = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      chunkIndex: null == chunkIndex
          ? _value.chunkIndex
          : chunkIndex // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentChunkImplCopyWith<$Res>
    implements $DocumentChunkCopyWith<$Res> {
  factory _$$DocumentChunkImplCopyWith(
          _$DocumentChunkImpl value, $Res Function(_$DocumentChunkImpl) then) =
      __$$DocumentChunkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String documentId, int chunkIndex, String text, String uri});
}

/// @nodoc
class __$$DocumentChunkImplCopyWithImpl<$Res>
    extends _$DocumentChunkCopyWithImpl<$Res, _$DocumentChunkImpl>
    implements _$$DocumentChunkImplCopyWith<$Res> {
  __$$DocumentChunkImplCopyWithImpl(
      _$DocumentChunkImpl _value, $Res Function(_$DocumentChunkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentId = null,
    Object? chunkIndex = null,
    Object? text = null,
    Object? uri = null,
  }) {
    return _then(_$DocumentChunkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      chunkIndex: null == chunkIndex
          ? _value.chunkIndex
          : chunkIndex // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentChunkImpl implements _DocumentChunk {
  const _$DocumentChunkImpl(
      {required this.id,
      required this.documentId,
      required this.chunkIndex,
      required this.text,
      required this.uri});

  factory _$DocumentChunkImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentChunkImplFromJson(json);

  @override
  final String id;
// unique within corpus
  @override
  final String documentId;
// original doc id (e.g. filename)
  @override
  final int chunkIndex;
// sequential number
  @override
  final String text;
  @override
  final String uri;

  @override
  String toString() {
    return 'DocumentChunk(id: $id, documentId: $documentId, chunkIndex: $chunkIndex, text: $text, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentChunkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.chunkIndex, chunkIndex) ||
                other.chunkIndex == chunkIndex) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, documentId, chunkIndex, text, uri);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentChunkImplCopyWith<_$DocumentChunkImpl> get copyWith =>
      __$$DocumentChunkImplCopyWithImpl<_$DocumentChunkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentChunkImplToJson(
      this,
    );
  }
}

abstract class _DocumentChunk implements DocumentChunk {
  const factory _DocumentChunk(
      {required final String id,
      required final String documentId,
      required final int chunkIndex,
      required final String text,
      required final String uri}) = _$DocumentChunkImpl;

  factory _DocumentChunk.fromJson(Map<String, dynamic> json) =
      _$DocumentChunkImpl.fromJson;

  @override
  String get id;
  @override // unique within corpus
  String get documentId;
  @override // original doc id (e.g. filename)
  int get chunkIndex;
  @override // sequential number
  String get text;
  @override
  String get uri;
  @override
  @JsonKey(ignore: true)
  _$$DocumentChunkImplCopyWith<_$DocumentChunkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

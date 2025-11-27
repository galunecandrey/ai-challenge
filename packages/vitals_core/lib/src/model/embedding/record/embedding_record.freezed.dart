// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'embedding_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmbeddingRecord _$EmbeddingRecordFromJson(Map<String, dynamic> json) {
  return _EmbeddingRecord.fromJson(json);
}

/// @nodoc
mixin _$EmbeddingRecord {
  String get chunkId => throw _privateConstructorUsedError;
  List<double> get embedding => throw _privateConstructorUsedError;
  String get documentId => throw _privateConstructorUsedError;
  int get chunkIndex => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmbeddingRecordCopyWith<EmbeddingRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmbeddingRecordCopyWith<$Res> {
  factory $EmbeddingRecordCopyWith(
          EmbeddingRecord value, $Res Function(EmbeddingRecord) then) =
      _$EmbeddingRecordCopyWithImpl<$Res, EmbeddingRecord>;
  @useResult
  $Res call(
      {String chunkId,
      List<double> embedding,
      String documentId,
      int chunkIndex,
      String text,
      String model,
      String uri});
}

/// @nodoc
class _$EmbeddingRecordCopyWithImpl<$Res, $Val extends EmbeddingRecord>
    implements $EmbeddingRecordCopyWith<$Res> {
  _$EmbeddingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chunkId = null,
    Object? embedding = null,
    Object? documentId = null,
    Object? chunkIndex = null,
    Object? text = null,
    Object? model = null,
    Object? uri = null,
  }) {
    return _then(_value.copyWith(
      chunkId: null == chunkId
          ? _value.chunkId
          : chunkId // ignore: cast_nullable_to_non_nullable
              as String,
      embedding: null == embedding
          ? _value.embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
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
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmbeddingRecordImplCopyWith<$Res>
    implements $EmbeddingRecordCopyWith<$Res> {
  factory _$$EmbeddingRecordImplCopyWith(_$EmbeddingRecordImpl value,
          $Res Function(_$EmbeddingRecordImpl) then) =
      __$$EmbeddingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String chunkId,
      List<double> embedding,
      String documentId,
      int chunkIndex,
      String text,
      String model,
      String uri});
}

/// @nodoc
class __$$EmbeddingRecordImplCopyWithImpl<$Res>
    extends _$EmbeddingRecordCopyWithImpl<$Res, _$EmbeddingRecordImpl>
    implements _$$EmbeddingRecordImplCopyWith<$Res> {
  __$$EmbeddingRecordImplCopyWithImpl(
      _$EmbeddingRecordImpl _value, $Res Function(_$EmbeddingRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chunkId = null,
    Object? embedding = null,
    Object? documentId = null,
    Object? chunkIndex = null,
    Object? text = null,
    Object? model = null,
    Object? uri = null,
  }) {
    return _then(_$EmbeddingRecordImpl(
      chunkId: null == chunkId
          ? _value.chunkId
          : chunkId // ignore: cast_nullable_to_non_nullable
              as String,
      embedding: null == embedding
          ? _value._embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as List<double>,
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
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
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
class _$EmbeddingRecordImpl implements _EmbeddingRecord {
  const _$EmbeddingRecordImpl(
      {required this.chunkId,
      required final List<double> embedding,
      required this.documentId,
      required this.chunkIndex,
      required this.text,
      required this.model,
      required this.uri})
      : _embedding = embedding;

  factory _$EmbeddingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmbeddingRecordImplFromJson(json);

  @override
  final String chunkId;
  final List<double> _embedding;
  @override
  List<double> get embedding {
    if (_embedding is EqualUnmodifiableListView) return _embedding;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_embedding);
  }

  @override
  final String documentId;
  @override
  final int chunkIndex;
  @override
  final String text;
  @override
  final String model;
  @override
  final String uri;

  @override
  String toString() {
    return 'EmbeddingRecord(chunkId: $chunkId, embedding: $embedding, documentId: $documentId, chunkIndex: $chunkIndex, text: $text, model: $model, uri: $uri)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmbeddingRecordImpl &&
            (identical(other.chunkId, chunkId) || other.chunkId == chunkId) &&
            const DeepCollectionEquality()
                .equals(other._embedding, _embedding) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.chunkIndex, chunkIndex) ||
                other.chunkIndex == chunkIndex) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.uri, uri) || other.uri == uri));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      chunkId,
      const DeepCollectionEquality().hash(_embedding),
      documentId,
      chunkIndex,
      text,
      model,
      uri);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmbeddingRecordImplCopyWith<_$EmbeddingRecordImpl> get copyWith =>
      __$$EmbeddingRecordImplCopyWithImpl<_$EmbeddingRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmbeddingRecordImplToJson(
      this,
    );
  }
}

abstract class _EmbeddingRecord implements EmbeddingRecord {
  const factory _EmbeddingRecord(
      {required final String chunkId,
      required final List<double> embedding,
      required final String documentId,
      required final int chunkIndex,
      required final String text,
      required final String model,
      required final String uri}) = _$EmbeddingRecordImpl;

  factory _EmbeddingRecord.fromJson(Map<String, dynamic> json) =
      _$EmbeddingRecordImpl.fromJson;

  @override
  String get chunkId;
  @override
  List<double> get embedding;
  @override
  String get documentId;
  @override
  int get chunkIndex;
  @override
  String get text;
  @override
  String get model;
  @override
  String get uri;
  @override
  @JsonKey(ignore: true)
  _$$EmbeddingRecordImplCopyWith<_$EmbeddingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

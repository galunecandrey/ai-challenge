// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedding_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class EmbeddingEntity extends _EmbeddingEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  EmbeddingEntity(
    String chunkId,
    String documentId,
    int chunkIndex,
    String text,
    String model, {
    Iterable<double> embedding = const [],
  }) {
    RealmObjectBase.set(this, '_id', chunkId);
    RealmObjectBase.set<RealmList<double>>(
        this, 'embedding', RealmList<double>(embedding));
    RealmObjectBase.set(this, 'documentId', documentId);
    RealmObjectBase.set(this, 'chunkIndex', chunkIndex);
    RealmObjectBase.set(this, 'text', text);
    RealmObjectBase.set(this, 'model', model);
  }

  EmbeddingEntity._();

  @override
  String get chunkId => RealmObjectBase.get<String>(this, '_id') as String;
  @override
  set chunkId(String value) => RealmObjectBase.set(this, '_id', value);

  @override
  RealmList<double> get embedding =>
      RealmObjectBase.get<double>(this, 'embedding') as RealmList<double>;
  @override
  set embedding(covariant RealmList<double> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get documentId =>
      RealmObjectBase.get<String>(this, 'documentId') as String;
  @override
  set documentId(String value) =>
      RealmObjectBase.set(this, 'documentId', value);

  @override
  int get chunkIndex => RealmObjectBase.get<int>(this, 'chunkIndex') as int;
  @override
  set chunkIndex(int value) => RealmObjectBase.set(this, 'chunkIndex', value);

  @override
  String get text => RealmObjectBase.get<String>(this, 'text') as String;
  @override
  set text(String value) => RealmObjectBase.set(this, 'text', value);

  @override
  String get model => RealmObjectBase.get<String>(this, 'model') as String;
  @override
  set model(String value) => RealmObjectBase.set(this, 'model', value);

  @override
  Stream<RealmObjectChanges<EmbeddingEntity>> get changes =>
      RealmObjectBase.getChanges<EmbeddingEntity>(this);

  @override
  Stream<RealmObjectChanges<EmbeddingEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<EmbeddingEntity>(this, keyPaths);

  @override
  EmbeddingEntity freeze() =>
      RealmObjectBase.freezeObject<EmbeddingEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': chunkId.toEJson(),
      'embedding': embedding.toEJson(),
      'documentId': documentId.toEJson(),
      'chunkIndex': chunkIndex.toEJson(),
      'text': text.toEJson(),
      'model': model.toEJson(),
    };
  }

  static EJsonValue _toEJson(EmbeddingEntity value) => value.toEJson();
  static EmbeddingEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue chunkId,
        'documentId': EJsonValue documentId,
        'chunkIndex': EJsonValue chunkIndex,
        'text': EJsonValue text,
        'model': EJsonValue model,
      } =>
        EmbeddingEntity(
          fromEJson(chunkId),
          fromEJson(documentId),
          fromEJson(chunkIndex),
          fromEJson(text),
          fromEJson(model),
          embedding: fromEJson(ejson['embedding']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(EmbeddingEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, EmbeddingEntity, 'EmbeddingEntity', [
      SchemaProperty('chunkId', RealmPropertyType.string,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('embedding', RealmPropertyType.double,
          collectionType: RealmCollectionType.list),
      SchemaProperty('documentId', RealmPropertyType.string),
      SchemaProperty('chunkIndex', RealmPropertyType.int),
      SchemaProperty('text', RealmPropertyType.string),
      SchemaProperty('model', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

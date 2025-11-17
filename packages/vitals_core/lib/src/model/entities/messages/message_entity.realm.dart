// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MessageEntity extends _MessageEntity
    with RealmEntity, RealmObjectBase, RealmObject {
  MessageEntity(
    String id,
    String role,
    String text,
    String sessionKey,
    int unixTime,
    bool isActive,
    bool isCompressed, {
    UsageDataEntity? usage,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'text', text);
    RealmObjectBase.set(this, 'sessionKey', sessionKey);
    RealmObjectBase.set(this, 'unixTime', unixTime);
    RealmObjectBase.set(this, 'isActive', isActive);
    RealmObjectBase.set(this, 'isCompressed', isCompressed);
    RealmObjectBase.set(this, 'usage', usage);
  }

  MessageEntity._();

  @override
  String get id => RealmObjectBase.get<String>(this, '_id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get role => RealmObjectBase.get<String>(this, 'role') as String;
  @override
  set role(String value) => RealmObjectBase.set(this, 'role', value);

  @override
  String get text => RealmObjectBase.get<String>(this, 'text') as String;
  @override
  set text(String value) => RealmObjectBase.set(this, 'text', value);

  @override
  String get sessionKey =>
      RealmObjectBase.get<String>(this, 'sessionKey') as String;
  @override
  set sessionKey(String value) =>
      RealmObjectBase.set(this, 'sessionKey', value);

  @override
  int get unixTime => RealmObjectBase.get<int>(this, 'unixTime') as int;
  @override
  set unixTime(int value) => RealmObjectBase.set(this, 'unixTime', value);

  @override
  bool get isActive => RealmObjectBase.get<bool>(this, 'isActive') as bool;
  @override
  set isActive(bool value) => RealmObjectBase.set(this, 'isActive', value);

  @override
  bool get isCompressed =>
      RealmObjectBase.get<bool>(this, 'isCompressed') as bool;
  @override
  set isCompressed(bool value) =>
      RealmObjectBase.set(this, 'isCompressed', value);

  @override
  UsageDataEntity? get usage =>
      RealmObjectBase.get<UsageDataEntity>(this, 'usage') as UsageDataEntity?;
  @override
  set usage(covariant UsageDataEntity? value) =>
      RealmObjectBase.set(this, 'usage', value);

  @override
  Stream<RealmObjectChanges<MessageEntity>> get changes =>
      RealmObjectBase.getChanges<MessageEntity>(this);

  @override
  Stream<RealmObjectChanges<MessageEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<MessageEntity>(this, keyPaths);

  @override
  MessageEntity freeze() => RealmObjectBase.freezeObject<MessageEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'role': role.toEJson(),
      'text': text.toEJson(),
      'sessionKey': sessionKey.toEJson(),
      'unixTime': unixTime.toEJson(),
      'isActive': isActive.toEJson(),
      'isCompressed': isCompressed.toEJson(),
      'usage': usage.toEJson(),
    };
  }

  static EJsonValue _toEJson(MessageEntity value) => value.toEJson();
  static MessageEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'role': EJsonValue role,
        'text': EJsonValue text,
        'sessionKey': EJsonValue sessionKey,
        'unixTime': EJsonValue unixTime,
        'isActive': EJsonValue isActive,
        'isCompressed': EJsonValue isCompressed,
      } =>
        MessageEntity(
          fromEJson(id),
          fromEJson(role),
          fromEJson(text),
          fromEJson(sessionKey),
          fromEJson(unixTime),
          fromEJson(isActive),
          fromEJson(isCompressed),
          usage: fromEJson(ejson['usage']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(MessageEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, MessageEntity, 'MessageEntity', [
      SchemaProperty('id', RealmPropertyType.string,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('role', RealmPropertyType.string),
      SchemaProperty('text', RealmPropertyType.string),
      SchemaProperty('sessionKey', RealmPropertyType.string),
      SchemaProperty('unixTime', RealmPropertyType.int),
      SchemaProperty('isActive', RealmPropertyType.bool),
      SchemaProperty('isCompressed', RealmPropertyType.bool),
      SchemaProperty('usage', RealmPropertyType.object,
          optional: true, linkTarget: 'UsageDataEntity'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UsageDataEntity extends _UsageDataEntity
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  UsageDataEntity({
    int? requestTokens,
    int? responseTokens,
    int? totalTokens,
    int? time,
  }) {
    RealmObjectBase.set(this, 'requestTokens', requestTokens);
    RealmObjectBase.set(this, 'responseTokens', responseTokens);
    RealmObjectBase.set(this, 'totalTokens', totalTokens);
    RealmObjectBase.set(this, 'time', time);
  }

  UsageDataEntity._();

  @override
  int? get requestTokens =>
      RealmObjectBase.get<int>(this, 'requestTokens') as int?;
  @override
  set requestTokens(int? value) =>
      RealmObjectBase.set(this, 'requestTokens', value);

  @override
  int? get responseTokens =>
      RealmObjectBase.get<int>(this, 'responseTokens') as int?;
  @override
  set responseTokens(int? value) =>
      RealmObjectBase.set(this, 'responseTokens', value);

  @override
  int? get totalTokens => RealmObjectBase.get<int>(this, 'totalTokens') as int?;
  @override
  set totalTokens(int? value) =>
      RealmObjectBase.set(this, 'totalTokens', value);

  @override
  int? get time => RealmObjectBase.get<int>(this, 'time') as int?;
  @override
  set time(int? value) => RealmObjectBase.set(this, 'time', value);

  @override
  Stream<RealmObjectChanges<UsageDataEntity>> get changes =>
      RealmObjectBase.getChanges<UsageDataEntity>(this);

  @override
  Stream<RealmObjectChanges<UsageDataEntity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UsageDataEntity>(this, keyPaths);

  @override
  UsageDataEntity freeze() =>
      RealmObjectBase.freezeObject<UsageDataEntity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'requestTokens': requestTokens.toEJson(),
      'responseTokens': responseTokens.toEJson(),
      'totalTokens': totalTokens.toEJson(),
      'time': time.toEJson(),
    };
  }

  static EJsonValue _toEJson(UsageDataEntity value) => value.toEJson();
  static UsageDataEntity _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return UsageDataEntity(
      requestTokens: fromEJson(ejson['requestTokens']),
      responseTokens: fromEJson(ejson['responseTokens']),
      totalTokens: fromEJson(ejson['totalTokens']),
      time: fromEJson(ejson['time']),
    );
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UsageDataEntity._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.embeddedObject, UsageDataEntity, 'UsageDataEntity', [
      SchemaProperty('requestTokens', RealmPropertyType.int, optional: true),
      SchemaProperty('responseTokens', RealmPropertyType.int, optional: true),
      SchemaProperty('totalTokens', RealmPropertyType.int, optional: true),
      SchemaProperty('time', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

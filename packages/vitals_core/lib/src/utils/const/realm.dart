import 'package:realm/realm.dart';
import 'package:vitals_core/src/model/entities/messages/message_entity.dart';

final kSchemasEntities = List<SchemaObject>.unmodifiable(
  <SchemaObject>[
    MessageEntity.schema,
    UsageDataEntity.schema,
  ],
);

const kRealmName = 'realm';

const kSchemaVersion = 1;

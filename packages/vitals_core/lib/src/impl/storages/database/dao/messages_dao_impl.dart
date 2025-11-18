import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/storage/base/base_realm_storage.dart' show BaseRealmStorage;
import 'package:vitals_core/src/api/storage/database/dao/messages_dao.dart' show MessagesDao;
import 'package:vitals_core/src/model/entities/messages/message_entity.dart' show MessageEntity, MessageEntityExt;
import 'package:vitals_core/src/model/message/message.dart' show Message, MessageExt;
import 'package:vitals_core/src/utils/const/dao.dart' show DaoClasses;

@LazySingleton(as: MessagesDao)
final class MessagesDaoImpl extends BaseRealmStorage<Message, MessageEntity> implements MessagesDao {
  MessagesDaoImpl({
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.operationService,
    @Named('isTestMode') super.isTest,
  }) : super(
          name: DaoClasses.kMessages,
        );

  @override
  Message mapFromEntity(MessageEntity data) => data.toModel;

  @override
  MessageEntity mapToEntity(Message data) => data.toEntity;

  @override
  String getModelId(Message data) => data.id;
}

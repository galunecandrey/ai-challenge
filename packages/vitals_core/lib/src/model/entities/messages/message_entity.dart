import 'package:realm/realm.dart';
import 'package:vitals_core/src/model/message/message.dart' show Message, MessageRolesStringExt;
import 'package:vitals_core/src/model/message/usage_data.dart';
import 'package:vitals_utils/vitals_utils.dart';

part 'message_entity.realm.dart';

@RealmModel()
class _MessageEntity {
  @MapTo('_id')
  @PrimaryKey()
  late String id;
  late String role;
  late String text;
  late String sessionKey;
  late int unixTime;
  late bool isActive;
  late bool isCompressed;
  _UsageDataEntity? usage;
}

extension MessageEntityExt on MessageEntity {
  Message get toModel => Message(
        id: id,
        role: role.toMessageRole,
        text: text,
        unixTime: unixTime,
        isActive: isActive,
        isCompressed: isCompressed,
        usage: usage?.toModel,
        sessionKey: sessionKey,
      );
}

@RealmModel(ObjectType.embeddedObject)
class _UsageDataEntity {
  int? requestTokens;
  int? responseTokens;
  int? totalTokens;
  int? time;
}

extension UsageDataEntityExt on UsageDataEntity {
  UsageData get toModel => UsageData(
        requestTokens: requestTokens,
        responseTokens: responseTokens,
        totalTokens: totalTokens,
        time: time?.let((it) => Duration(milliseconds: it)),
      );
}

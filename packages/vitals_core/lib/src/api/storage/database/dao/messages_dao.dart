import 'package:vitals_core/src/api/storage/database/dao/base/base_dao.dart' show BaseDao;
import 'package:vitals_core/src/api/storage/database/dao/base/query_dao.dart' show QueryDao;
import 'package:vitals_core/src/model/message/message.dart' show Message;

abstract interface class MessagesDao implements BaseDao<Message>, QueryDao<Message> {}

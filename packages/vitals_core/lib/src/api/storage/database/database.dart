import 'package:vitals_core/src/api/storage/database/dao/ai_session_dao.dart';
import 'package:vitals_core/src/api/storage/database/dao/embedding_dao.dart';
import 'package:vitals_core/src/api/storage/database/dao/messages_dao.dart' show MessagesDao;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

abstract interface class Database {
  String? get id;

  EmbeddingDao get embedding;

  MessagesDao get messages;

  AISessionDao get session;

  Future<Either<BaseError, Unit>> init([String? subDir]);

  Future<Either<BaseError, Unit>> close();

  Future<Either<BaseError, Unit>> clear();
}

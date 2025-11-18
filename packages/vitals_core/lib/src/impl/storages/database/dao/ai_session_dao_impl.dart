import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/storage/base/base_box_storage.dart' show BaseBoxStorage;
import 'package:vitals_core/src/api/storage/database/dao/ai_session_dao.dart';
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/utils/const/dao.dart' show DaoClasses, DaoVersions;
import 'package:vitals_core/src/utils/const/secure_keys.dart' show SecureKeys;

@LazySingleton(as: AISessionDao)
final class AISessionDaoImpl extends BaseBoxStorage<AISession> implements AISessionDao {
  AISessionDaoImpl({
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.operationService,
    @Named('isTestMode') super.isTest,
  }) : super(
          name: DaoClasses.kSessions,
          secureKey: SecureKeys.kSessions,
          version: DaoVersions.kSessions,
        );

  @override
  String getBoxKey(AISession data) => data.key;
}

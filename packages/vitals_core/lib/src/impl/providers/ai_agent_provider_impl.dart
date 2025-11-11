import 'package:injectable/injectable.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/api/providers/ai_agent_provider.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/impl/storages/ai_agent_storage.dart';
import 'package:vitals_core/src/impl/storages/messages_storage.dart' show MessagesStorage;
import 'package:vitals_core/src/model/enums/ai_agents_enum.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: AIAgentProvider)
final class AIRepositoryImpl implements AIAgentProvider {
  AIRepositoryImpl(
    this._client,
    this._messagesStorage,
    this._operationService,
    this._dateTimeProvider,
    this._aiAgentStorage,
  );

  final OpenAIClient _client;
  final OperationService _operationService;
  final MessagesStorage _messagesStorage;
  final DateTimeProvider _dateTimeProvider;
  final AIAgentStorage _aiAgentStorage;

  @override
  Either<BaseError, AIAgent> get(AIAgents agent) {
    final key = agent.key;
    if (!_aiAgentStorage.contains(key)) {
      _operationService.safeSyncOp(
        () => _aiAgentStorage.set(
          key,
          AIAgent(
            agent,
            _client,
            _messagesStorage,
            _operationService,
            _dateTimeProvider,
          ),
        ),
      );
    }
    return _aiAgentStorage.get(key);
  }
}

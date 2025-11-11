import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/providers/ai_agent_provider.dart';
import 'package:vitals_core/src/api/repositories/ai_repository.dart' show AIRepository;
import 'package:vitals_core/src/model/enums/ai_agents_enum.dart';
import 'package:vitals_core/src/model/message/message.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: AIRepository)
final class AIRepositoryImpl implements AIRepository {
  AIRepositoryImpl(
    this._aiAgentProvider,
  );

  final AIAgentProvider _aiAgentProvider;

  @override
  Either<BaseError, Unit> clearAIAgentContext(AIAgents agent) => _aiAgentProvider.get(agent).map((r) {
        r.clearContext();
        return unit;
      });

  @override
  Either<BaseError, Unit> clearAll() {
    for (final agent in AIAgents.values) {
      clearAIAgentContext(agent);
    }
    return right<BaseError, Unit>(unit);
  }

  @override
  Either<BaseError, List<Message>> getAIAgentContext(AIAgents agent) => _aiAgentProvider.get(agent).fold(
        (l) => left(l),
        (r) => r.context,
      );

  @override
  Stream<Either<BaseError, List<Message>>> getAIAgentContextStream(AIAgents agent, {bool sendFirst = false}) =>
      _aiAgentProvider.get(agent).fold(
            (l) => const Stream.empty(),
            (r) => r.getContextStream(sendFirst: sendFirst),
          );

  @override
  Future<Either<BaseError, Message>> sendRequestToAgent(AIAgents agent, String text) =>
      _aiAgentProvider.get(agent).fold(
            (l) async => left(l),
            (r) => r.sendRequest(text),
          );

  @override
  Future<Either<BaseError, Unit>> sendRequestToAll(String text) {
    info('sendRequestToAll');
    return Future.wait([
      for (final agent in AIAgents.values) sendRequestToAgent(agent, text),
    ]).then((v) => right<BaseError, Unit>(unit));
  }
}

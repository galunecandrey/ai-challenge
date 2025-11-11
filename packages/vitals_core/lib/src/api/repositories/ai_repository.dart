import 'package:vitals_core/src/model/enums/ai_agents_enum.dart';
import 'package:vitals_core/src/model/message/message.dart' show Message;
import 'package:vitals_utils/vitals_utils.dart';

abstract interface class AIRepository {
  Future<Either<BaseError, Message>> sendRequestToAgent(AIAgents agent, String text);

  Future<Either<BaseError, Unit>> sendRequestToAll(String text);

  Either<BaseError, List<Message>> getAIAgentContext(AIAgents agent);

  Stream<Either<BaseError, List<Message>>> getAIAgentContextStream(AIAgents agent, {bool sendFirst = false});

  Either<BaseError, Unit> clearAIAgentContext(AIAgents agent);

  Either<BaseError, Unit> clearAll();
}

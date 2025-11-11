import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/model/enums/ai_agents_enum.dart';
import 'package:vitals_utils/vitals_utils.dart';

//ignore: one_member_abstracts
abstract interface class AIAgentProvider {
  Either<BaseError, AIAgent> get(AIAgents agent);
}

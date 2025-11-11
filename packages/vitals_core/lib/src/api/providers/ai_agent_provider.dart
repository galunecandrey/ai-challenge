import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/model/ai_agent_options/ai_agent_options.dart';

//ignore: one_member_abstracts
abstract interface class AIAgentProvider {
  AIAgent get(AIAgentOptions options);
}

import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/model/enums/ai_agent_types.dart' show AIAgentTypes;

//ignore: one_member_abstracts
abstract interface class AIAgentProvider {
  AIAgent get(
    AISession options, {
    AIAgentTypes type = AIAgentTypes.deff,
  });
}

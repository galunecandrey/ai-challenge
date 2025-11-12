import 'package:vitals_core/src/model/ai_agent_options/ai_agent_options.dart';
import 'package:vitals_core/src/model/enums/ai_agent_types.dart';
import 'package:vitals_core/src/utils/const/prompts.dart';

enum AIAgentsOptions {
  simple(
    options: AIAgentOptions(
      key: 'simple',
      name: 'gpt-5',
      model: 'gpt-5',
    ),
  ),
  simpleWithByStep(
    options: AIAgentOptions(
      key: 'simpleWithByStep',
      name: 'By Step',
      systemPrompt: kSystemStepByStep,
      model: 'gpt-5',
    ),
  ),
  simpleGPT5mini(
    options: AIAgentOptions(
      key: 'simpleGPT5mini',
      name: 'gpt-5-mini',
      model: 'gpt-5-mini',
    ),
  ),
  simpleGPT5nano(
    options: AIAgentOptions(
      key: 'simpleGPT5nano',
      name: 'gpt-5-nano',
      model: 'gpt-5-nano',
    ),
  ),
  simpleGPT4_1(
    options: AIAgentOptions(
      key: 'simpleGPT4_1',
      name: 'gpt-4.1',
    ),
  ),
  physicist(
    options: AIAgentOptions(
      key: 'physicist',
      name: 'Physicist',
      systemPrompt: kSystemPhysicist,
      model: 'gpt-5',
    ),
  ),
  mathematician(
    options: AIAgentOptions(
      key: 'mathematician',
      name: 'Mathematician',
      systemPrompt: kSystemMathematician,
      model: 'gpt-5',
    ),
  ),
  philosopher(
    options: AIAgentOptions(
      key: 'philosopher',
      name: 'Philosopher',
      systemPrompt: kSystemPhilosopher,
      model: 'gpt-5',
    ),
  ),
  multirole(
    options: AIAgentOptions(
      key: 'multirole',
      name: 'Multi',
      systemPrompt: kSystemMulti,
      model: 'gpt-5',
    ),
  ),
  sao10K(
    options: AIAgentOptions(
      key: 'L3-8B-Stheno-v3.2',
      name: 'L3-8B-Stheno-v3.2',
      model: 'Sao10K/L3-8B-Stheno-v3.2:novita',
    ),
    type: AIAgentTypes.huggingface,
  ),
  miniMaxAI(
    options: AIAgentOptions(
      key: 'MiniMax-M2',
      name: 'MiniMax-M2',
      model: 'MiniMaxAI/MiniMax-M2:novita',
    ),
    type: AIAgentTypes.huggingface,
  ),
  qwen(
    options: AIAgentOptions(
      key: 'Qwen2.5-VL-7B-Instruct',
      name: 'Qwen2.5-VL-7B-Instruct',
      model: 'Qwen/Qwen2.5-VL-7B-Instruct:hyperbolic',
    ),
    type: AIAgentTypes.huggingface,
  );

  final AIAgentOptions options;

  final AIAgentTypes type;

  const AIAgentsOptions({
    required this.options,
    this.type = AIAgentTypes.deff,
  });
}

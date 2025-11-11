import 'package:vitals_core/src/utils/const/prompts.dart';

enum AIAgents {
  simple(key: 'simple', name: 'gpt-5'),
  simpleWithByStep(key: 'simpleWithByStep', name: 'By Step', systemPrompt: kSystemStepByStep),
  simpleGPT5mini(key: 'simpleGPT5mini', model: 'gpt-5-mini'),
  simpleGPT5nano(key: 'simpleGPT5nano', model: 'gpt-5-nano'),
  simpleGPT4_1(key: 'simpleGPT4_1', model: 'gpt-4.1'),
  physicist(key: 'physicist', name: 'Physicist', systemPrompt: kSystemPhysicist),
  mathematician(key: 'mathematician', name: 'Mathematician', systemPrompt: kSystemMathematician),
  philosopher(key: 'philosopher', name: 'Philosopher', systemPrompt: kSystemPhilosopher),
  multirole(key: 'multirole', name: 'Multi', systemPrompt: kSystemMulti);

  final String key;
  final String? name;
  final String? systemPrompt;
  final String model;

  const AIAgents({
    required this.key,
    this.name,
    this.systemPrompt,
    this.model = 'gpt-5',
  });
}

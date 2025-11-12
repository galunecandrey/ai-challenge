import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_agent_options.freezed.dart';

@freezed
sealed class AIAgentOptions with _$AIAgentOptions {
  const factory AIAgentOptions({
    required String key,
    String? name,
    String? systemPrompt,
    @Default('gpt-4.1') String model,
  }) = _AIAgentOptions;
}

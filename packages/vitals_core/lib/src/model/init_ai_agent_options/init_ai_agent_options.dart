import 'package:freezed_annotation/freezed_annotation.dart';

part 'init_ai_agent_options.freezed.dart';

@freezed
sealed class InitAIAgentOptions with _$InitAIAgentOptions {
  const factory InitAIAgentOptions({
    required String baseUrl,
    required String apikey,
  }) = _InitAIAgentOptions;
}

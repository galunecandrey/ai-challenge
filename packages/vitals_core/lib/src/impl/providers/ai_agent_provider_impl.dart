import 'package:injectable/injectable.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/api/providers/ai_agent_provider.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/impl/ai/ai_agent_impl.dart' show AIAgentImpl;
import 'package:vitals_core/src/model/ai_agent_options/ai_agent_options.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: AIAgentProvider)
final class AIRepositoryImpl implements AIAgentProvider {
  AIRepositoryImpl(
    this._client,
    this._operationService,
    this._dateTimeProvider,
  );

  final OpenAIClient _client;
  final OperationService _operationService;
  final DateTimeProvider _dateTimeProvider;

  @override
  AIAgent get(AIAgentOptions options) => AIAgentImpl(
        options,
        _client,
        _operationService,
        _dateTimeProvider,
      );
}

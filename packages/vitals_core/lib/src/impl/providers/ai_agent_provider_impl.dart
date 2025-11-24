import 'package:injectable/injectable.dart';
import 'package:mcp_client/mcp_client.dart' show McpClient, TransportConfig;
import 'package:openai_dart/openai_dart.dart';
import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/ai/ai_mcp_client.dart';
import 'package:vitals_core/src/api/providers/ai_agent_provider.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart';
import 'package:vitals_core/src/api/storage/database/database.dart';
import 'package:vitals_core/src/impl/ai/ai_agent_impl.dart' show AIAgentImpl;
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/model/enums/ai_agent_types.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: AIAgentProvider)
final class AIRepositoryImpl implements AIAgentProvider {
  AIRepositoryImpl(
    this._client,
    @Named('huggingfaceAIClient') this._huggingfaceClient,
    this._operationService,
    this._dateTimeProvider,
    this._database,
    @Named('GitHubAIKey') this._mcpToken,
  );

  final OpenAIClient _client;
  final OpenAIClient _huggingfaceClient;
  final OperationService _operationService;
  final DateTimeProvider _dateTimeProvider;
  final Database _database;
  final String _mcpToken;

  @override
  AIAgent get(
    AISession options, {
    AIAgentTypes type = AIAgentTypes.deff,
  }) =>
      AIAgentImpl(
        options,
        type == AIAgentTypes.huggingface ? _huggingfaceClient : _client,
        _operationService,
        _dateTimeProvider,
        _database,
      )
        ..addMCPClient(
          AiMcpClient.create(
            _operationService,
            clientConfig: McpClient.simpleConfig(
              name: 'flutter_sse_client',
              version: '1.0.0',
              enableDebugLogging: true,
            ),
            transportConfig: const TransportConfig.sse(
              serverUrl: 'http://localhost:8080/sse',
              headers: {'User-Agent': 'MCP-Client/1.0'},
            ),
          ),
        )
        ..addMCPClient(
          AiMcpClient.create(
            _operationService,
            clientConfig: McpClient.simpleConfig(
              name: 'flutter_streamable_http_client',
              version: '1.0.0',
              enableDebugLogging: true,
            ),
            transportConfig: TransportConfig.streamableHttp(
              baseUrl: 'https://api.githubcopilot.com/mcp', // root MCP endpoint
              headers: {
                'User-Agent': 'Flutter-MCP-SSE/1.0',
                'Authorization': 'Bearer $_mcpToken',
              },
              useHttp2: true,
            ),
          ),
        );
}

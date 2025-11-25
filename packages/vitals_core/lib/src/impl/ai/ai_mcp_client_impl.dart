//ignore_for_file: close_sinks
import 'package:mcp_client/mcp_client.dart'
    show CallToolResult, Client, McpClient, McpClientConfig, Tool, TransportConfig;
import 'package:vitals_core/src/ai/ai_mcp_client.dart' show AiMcpClient;
import 'package:vitals_utils/vitals_utils.dart'
    show AsyncLazy, BaseError, Disposable, Either, OperationService, asyncLazy, info, left;

class AiMcpClientImpl extends Disposable implements AiMcpClient {
  final OperationService _operationService;
  late final _tools = stateOf<List<Tool>>(List.unmodifiable([]));
  late final AsyncLazy<Client> _client;

  Future<Client> get client => _client.value;

  AiMcpClientImpl(
    this._operationService, {
    required McpClientConfig clientConfig,
    required TransportConfig transportConfig,
    String? token,
  }) {
    _client = asyncLazy<Client>(
      () => _connectClient(
        clientConfig: clientConfig,
        transportConfig: transportConfig,
        token: token,
      ),
    );
  }

  @override
  bool isContainsTool(String name) {
    info('isContainsTool: $name in ${_tools.value.map((v) => v.name)}');
    return _tools.value.any((tool) => tool.name == name);
  }

  @override
  Future<Either<BaseError, List<Tool>>> listTools() {
    info('MCPClient.listTools');
    return _operationService.safeAsyncOp(() => client).then(
          (v) => v.fold(
            (l) async => left(l),
            (r) => _operationService.safeAsyncOp(
              () => r.listTools().then((v) {
                info('MCPClient.listTools result: ${v.map((v) => v.toJson())}');
                _tools.add(v);
                return v;
              }),
            ),
          ),
        );
  }

  @override
  Future<Either<BaseError, CallToolResult>> callTool(
    String name,
    Map<String, dynamic> toolArguments,
  ) {
    info('MCPClient.callTool');
    return _operationService.safeAsyncOp(() => client).then(
          (v) => v.fold(
            (l) async => left(l),
            (r) => _operationService.safeAsyncOp(
              () => r.callTool(name, toolArguments).then((v) {
                info('MCPClient.callTool.result: ${v.toJson()}');
                return v;
              }),
            ),
          ),
        );
  }

  Future<Client> _connectClient({
    required McpClientConfig clientConfig,
    required TransportConfig transportConfig,
    String? token,
  }) async {
    // final config = McpClient.simpleConfig(
    //   name: 'flutter_sse_client',
    //   version: '1.0.0',
    //   enableDebugLogging: true,
    // );
    //
    // const transportConfig = TransportConfig.sse(
    //   serverUrl: 'http://localhost:8080/sse',
    //   headers: {'User-Agent': 'MCP-Client/1.0'},
    // );

    // final transportConfig = TransportConfig.stdio(
    //   command: '/Users/andrii/Flutter/bin/cache/dart-sdk/bin/dart',
    //   arguments: const [
    //     '/Users/andrii/StudioProjects/ai-challenge/packages/vitals_core/bin/github_mcp_server.dart',
    //   ],
    //   environment: {
    //     'GITHUB_TOKEN': token,
    //   },
    // );
    // TransportConfig.streamableHttp(
    //   baseUrl: 'https://api.githubcopilot.com/mcp', // root MCP endpoint
    //   headers: {
    //     'User-Agent': 'Flutter-MCP-SSE/1.0',
    //     'Authorization': 'Bearer $token',
    //   },
    //   useHttp2: true,
    // );

    final result = await McpClient.createAndConnect(
      config: clientConfig,
      transportConfig: transportConfig,
    );
    info(result.fold((l) => l.serverInfo ?? l.name, (r) => r.toString()));

    return result.fold(
      (client) => client,
      (error) => throw Exception('Failed to connect: $error'),
    );
  }

  @override
  void dispose() {
    if (_client.isInitialized) {
      _operationService.safeUnitAsyncOp(
        () => client.then<void>((value) => value.dispose()),
      );
    }
    super.dispose();
  }
}

import 'package:mcp_client/mcp_client.dart' show CallToolResult, McpClientConfig, Tool, TransportConfig;
import 'package:vitals_core/src/impl/ai/ai_mcp_client_impl.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Disposable, Either, OperationService;

abstract interface class AiMcpClient extends Disposable {
  bool isContainsTool(String name);

  Future<Either<BaseError, List<Tool>>> listTools();

  Future<Either<BaseError, CallToolResult>> callTool(
    String name,
    Map<String, dynamic> toolArguments,
  );

  factory AiMcpClient.create(
    OperationService operationService, {
    required McpClientConfig clientConfig,
    required TransportConfig transportConfig,
    String? token,
  }) =>
      AiMcpClientImpl(
        operationService,
        clientConfig: clientConfig,
        transportConfig: transportConfig,
        token: token,
      );
}

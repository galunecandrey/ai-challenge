import 'package:mcp_client/mcp_client.dart' show CallToolResult, Tool;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Disposable, Either;

abstract interface class AiMcpClient extends Disposable {
  Future<Either<BaseError, List<Tool>>> listTools();

  Future<Either<BaseError, CallToolResult>> callTool(
    String name,
    Map<String, dynamic> toolArguments,
  );
}

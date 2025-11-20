import 'dart:io' show Process;

import 'package:mcp_client/mcp_client.dart';

Future<void> main(List<String> arguments) async {
  await Process.start(
    'dart',
    ['bin/github_mcp_server.dart'],
    environment: {
      'GITHUB_TOKEN': arguments[0],
    },
  );
  Client? client;

  final config = McpClient.simpleConfig(
    name: 'flutter_sse_client',
    version: '1.0.0',
    enableDebugLogging: true,
  );

  const transportConfig = TransportConfig.sse(
    serverUrl: 'http://localhost:8080/sse',
    headers: {'User-Agent': 'MCP-Client/1.0'},
  );

  ///TransportConfig.stdio(command: 'dart', arguments: ['bin/github_mcp_server.dart']);
  // TransportConfig.streamableHttp(
  //   baseUrl: 'https://api.githubcopilot.com/mcp', // root MCP endpoint
  //   headers: {
  //     'User-Agent': 'Flutter-MCP-SSE/1.0',
  //     'Authorization': 'Bearer ${arguments[0]}',
  //   },
  //   useHttp2: true,
  // );

  final result = await McpClient.createAndConnect(
    config: config,
    transportConfig: transportConfig,
  );

  client = result.fold(
    (client) => client,
    (error) => throw Exception('Failed to connect: $error'),
  );

  print('✅ Connected (SSE) to GitHub MCP Server');

  final resultListTools = await client?.listTools();
  print('=========================');
  print('LIST OG TOOLS');
  print('=========================');
  int number = 1;
  resultListTools?.forEach((tool) {
    print('---------Tool $number----------');
    print('Name: ${tool.name}');
    print('Description: ${tool.description}\n');
    print('InputSchema: ${tool.inputSchema}\n');
    print('Metadata: ${tool.metadata}\n');
    number++;
  });
  client?.disconnect();
  client?.dispose();
}

//ignore_for_file: avoid_dynamic_calls
import 'dart:convert';
import 'dart:io';

//ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mcp_server/mcp_server.dart';

/// Simple MCP server that wraps parts of the GitHub REST API.
///
/// Exposes:
/// - Tool: github_list_repos
/// - Tool: github_get_repo
/// - Tool: github_list_issues
/// - Resource: github://repo/{owner}/{repo}/readme
///
/// Configure GitHub token via env var: GITHUB_TOKEN
/// (recommended, but optional for public repos).
Future<void> main() async {
  final server = Server(
    name: 'GitHub MCP Server',
    version: '0.1.0',
    capabilities: ServerCapabilities.simple(
      tools: true,
      resources: true,
    ),
  );

  // Attach tools
  _registerGithubListReposTool(server);
  _registerGithubGetRepoTool(server);
  _registerGithubListIssuesTool(server);

  // Attach resource (README)
  //_registerGithubReadmeResource(server);

  // Connect server to stdio transport for MCP hosts
  final transportResult = McpServer.createTransport(
    const TransportConfig.sse(),
  );
  final transport = await transportResult.get();
  //final transportResult = McpServer.createStdioTransport();
  //final transport = transportResult.get();
  server.connect(transport);
}

/// Shared GitHub HTTP helper.
Future<http.Response> _githubRequest(
  String path, {
  Map<String, String>? query,
}) async {
  final baseUri = Uri.https('api.github.com', path, query);
  final token = Platform.environment['GITHUB_TOKEN'];

  final headers = <String, String>{
    'Accept': 'application/vnd.github+json',
    'User-Agent': 'github-mcp-server-dart',
  };

  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

  final response = await http.get(baseUri, headers: headers);

  return response;
}

/// Convert an HTTP error into a human-readable MCP tool result.
CallToolResult _httpErrorResult(http.Response response) {
  final status = response.statusCode;
  final body = response.body;

  final message = StringBuffer()
    ..writeln('GitHub API request failed.')
    ..writeln('Status: $status')
    ..writeln('Body: $body');

  return CallToolResult(
    content: [TextContent(text: message.toString())],
    isError: true,
  );
}

/// Safely stringify JSON for returning to the LLM.
String _prettyJson(dynamic data) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(data);
}

/// ---------- Tool: github_list_repos ----------
/// List repositories for a user or org.
void _registerGithubListReposTool(Server server) {
  server.addTool(
    name: 'github_list_repos',
    description: 'List GitHub repositories for a user or organization. '
        'Optionally filter by visibility.',
    inputSchema: {
      'type': 'object',
      'properties': {
        'owner': {
          'type': 'string',
          'description': 'GitHub username or organization name.',
        },
        'owner_type': {
          'type': 'string',
          'enum': ['user', 'org'],
          'description': 'Whether the owner is a "user" or "org". Default: "user".',
        },
        'per_page': {
          'type': 'integer',
          'description': 'Number of repositories per page (max 100). Default: 30.',
        },
        'page': {
          'type': 'integer',
          'description': 'Page number of the results to fetch. Default: 1.',
        },
      },
      'required': ['owner'],
    },
    handler: (arguments) async {
      final owner = arguments['owner'] as String;
      final ownerType = (arguments['owner_type'] as String?) ?? 'user';
      final perPage = (arguments['per_page'] as int?) ?? 30;
      final page = (arguments['page'] as int?) ?? 1;

      final path = switch (ownerType) {
        'org' => '/orgs/$owner/repos',
        _ => '/users/$owner/repos',
      };

      final response = await _githubRequest(
        path,
        query: {
          'per_page': perPage.toString(),
          'page': page.toString(),
        },
      );

      if (response.statusCode != 200) {
        return _httpErrorResult(response);
      }

      final data = jsonDecode(response.body) as List<dynamic>;

      // Return both a short text summary and the raw JSON.
      final summary = StringBuffer()
        ..writeln('Found ${data.length} repositories for "$owner" (page $page):')
        ..writeln()
        ..writeln(
          data
              .take(10)
              .map(
                (repo) => '- ${repo['full_name']} (⭐ ${repo['stargazers_count']}, '
                    'visibility: ${repo['visibility'] ?? 'unknown'})',
              )
              .join('\n'),
        );

      final jsonString = _prettyJson(data);

      return CallToolResult(
        content: [
          TextContent(text: summary.toString()),
          TextContent(
            text: '\n\n---\nRaw JSON (first page):\n```json\n$jsonString\n```',
          ),
        ],
      );
    },
  );
}

/// ---------- Tool: github_get_repo ----------
/// Get detailed information for a single repository.
void _registerGithubGetRepoTool(Server server) {
  server.addTool(
    name: 'github_get_repo',
    description: 'Get details for a single GitHub repository.',
    inputSchema: {
      'type': 'object',
      'properties': {
        'owner': {
          'type': 'string',
          'description': 'Repository owner (user or org).',
        },
        'repo': {
          'type': 'string',
          'description': 'Repository name.',
        },
      },
      'required': ['owner', 'repo'],
    },
    handler: (arguments) async {
      final owner = arguments['owner'] as String;
      final repo = arguments['repo'] as String;

      final response = await _githubRequest('/repos/$owner/$repo');

      if (response.statusCode != 200) {
        return _httpErrorResult(response);
      }

      final data = jsonDecode(response.body);

      final summary = StringBuffer()
        ..writeln('Repository: ${data['full_name']}')
        ..writeln('Description: ${data['description'] ?? '—'}')
        ..writeln('Stars: ${data['stargazers_count']}')
        ..writeln('Forks: ${data['forks_count']}')
        ..writeln('Open issues: ${data['open_issues_count']}')
        ..writeln('Default branch: ${data['default_branch']}')
        ..writeln('Visibility: ${data['visibility']}')
        ..writeln('HTML URL: ${data['html_url']}');

      final jsonString = _prettyJson(data);

      return CallToolResult(
        content: [
          TextContent(text: summary.toString()),
          TextContent(
            text: '\n\n---\nRaw JSON:\n```json\n$jsonString\n```',
          ),
        ],
      );
    },
  );
}

/// ---------- Tool: github_list_issues ----------
/// List issues for a repository.
void _registerGithubListIssuesTool(Server server) {
  server.addTool(
    name: 'github_list_issues',
    description: 'List issues for a GitHub repository. '
        'Includes both issues and pull requests unless filtered.',
    inputSchema: {
      'type': 'object',
      'properties': {
        'owner': {
          'type': 'string',
          'description': 'Repository owner (user or org).',
        },
        'repo': {
          'type': 'string',
          'description': 'Repository name.',
        },
        'state': {
          'type': 'string',
          'enum': ['open', 'closed', 'all'],
          'description': 'Issue state filter. Default: "open".',
        },
        'per_page': {
          'type': 'integer',
          'description': 'Number of issues per page (max 100). Default: 30.',
        },
        'page': {
          'type': 'integer',
          'description': 'Page number. Default: 1.',
        },
      },
      'required': ['owner', 'repo'],
    },
    handler: (arguments) async {
      final owner = arguments['owner'] as String;
      final repo = arguments['repo'] as String;
      final state = (arguments['state'] as String?) ?? 'open';
      final perPage = (arguments['per_page'] as int?) ?? 30;
      final page = (arguments['page'] as int?) ?? 1;

      final response = await _githubRequest(
        '/repos/$owner/$repo/issues',
        query: {
          'state': state,
          'per_page': perPage.toString(),
          'page': page.toString(),
        },
      );

      if (response.statusCode != 200) {
        return _httpErrorResult(response);
      }

      final data = jsonDecode(response.body) as List<dynamic>;

      // Short textual summary of top issues
      final summary = StringBuffer()
        ..writeln('Issues for $owner/$repo (state=$state, page=$page):')
        ..writeln();

      for (final issue in data.take(10)) {
        final number = issue['number'];
        final title = issue['title'];
        final stateVal = issue['state'];
        final isPr = issue['pull_request'] != null;
        summary.writeln('- #$number ${isPr ? "[PR] " : ""}$title (state: $stateVal)');
      }

      final jsonString = _prettyJson(data);

      return CallToolResult(
        content: [
          TextContent(text: summary.toString()),
          TextContent(
            text: '\n\n---\nRaw JSON:\n```json\n$jsonString\n```',
          ),
        ],
      );
    },
  );
}

/// ---------- Resource: github://repo/{owner}/{repo}/readme ----------
/// Expose a repository README as an MCP resource.
///
/// Example URI:
///   github://repo/dart-lang/sdk/readme
// void _registerGithubReadmeResource(Server server) {
//   server.addResource(
//     uri: 'github://repo/{owner}/{repo}/readme',
//     name: 'GitHub Repo README',
//     description: 'Fetch README of a GitHub repository as text.',
//     mimeType: 'text/markdown',
//     uriTemplate: {
//       'type': 'object',
//       'properties': {
//         'owner': {
//           'type': 'string',
//           'description': 'Repository owner (user or org).',
//         },
//         'repo': {
//           'type': 'string',
//           'description': 'Repository name.',
//         },
//       },
//       'required': ['owner', 'repo'],
//     },
//     handler: (uri, params) async {
//       final owner = params['owner'] as String;
//       final repo = params['repo'] as String;
//
//       // GitHub "Get a repository README" endpoint
//       final response = await _githubRequest('/repos/$owner/$repo/readme');
//
//       if (response.statusCode != 200) {
//         // Represent as a resource error by putting message in content
//         final errorResult = _httpErrorResult(response);
//         final errorText = (errorResult.content.first as TextContent).text;
//         return ReadResourceResult(
//           content: errorText,
//           mimeType: 'text/plain',
//           contents: [
//             ResourceContent(
//               uri: uri,
//               text: errorText,
//             ),
//           ],
//         );
//       }
//
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       final encoded = data['content'] as String;
//       final encoding = data['encoding'] as String? ?? 'base64';
//
//       String decoded;
//       if (encoding == 'base64') {
//         decoded = utf8.decode(base64Decode(encoded));
//       } else {
//         // Fallback: just return raw content
//         decoded = encoded;
//       }
//
//       return ReadResourceResult(
//         content: decoded,
//         mimeType: 'text/markdown',
//         contents: [
//           ResourceContent(
//             uri: uri,
//             text: decoded,
//           ),
//         ],
//       );
//     },
//   );
// }

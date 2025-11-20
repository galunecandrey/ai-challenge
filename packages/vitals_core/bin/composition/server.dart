import 'dart:async';
import 'dart:io';

import 'package:mcp_server/mcp_server.dart';

final _logger = Logger('mcp_composition_server');

Future<void> main(List<String> args) async {
  // Basic logging to stderr (doesn’t interfere with MCP stdio).
  Logger.root.level = Level.INFO;
  // Logger.root.onRecord.listen((record) {
  //   stderr.writeln('${record.level.name}: ${record.time}: ${record.message}');
  // });

  final isStdio = args.contains('--mcp-stdio-mode');

  await _startMcpServer(mode: isStdio ? 'stdio' : 'sse');
}

Future<void> _startMcpServer({required String mode, int port = 8080}) async {
  try {
    final serverResult = await McpServer.createAndStart(
      config: McpServer.simpleConfig(
        name: 'MCP Composition Server',
        version: '1.0.0',
        enableDebugLogging: true,
      ),
      transportConfig: mode == 'stdio'
          ? const TransportConfig.stdio()
          : TransportConfig.sse(
              port: port,
            ),
    );

    await serverResult.fold(
      (server) async {
        _registerTools(server);

        server.onDisconnect.listen((_) {
          _logger.info('Client disconnected, shutting down.');
          exit(0);
        });

        server.sendLog(McpLogLevel.info, 'MCP Composition Server started.');

        if (mode == 'sse') {
          _logger.info('SSE server on http://localhost:$port');
        } else {
          _logger.info('STDIO server initialized.');
        }

        // Keep server running
        await Future.delayed(const Duration(hours: 24));
      },
      (error) {
        _logger.severe('Error initializing MCP server: $error');
        exit(1);
      },
    );
  } catch (e, st) {
    _logger.severe('Error initializing MCP server: $e\n$st');
    exit(1);
  }
}

void _registerTools(Server server) {
  _registerSearchDocsTool(server);
  _registerSummarizeTool(server);
  _registerSaveToFileTool(server);
}

/// Tool 1: search_docs
///
/// Input:
/// {
///   "directory": "docs",
///   "query": "flutter"
/// }
///
/// Output: text with matched filenames and excerpts.
void _registerSearchDocsTool(Server server) {
  server.addTool(
    name: 'search_docs',
    description: 'Search .txt/.md files in a directory for a query string.',
    inputSchema: {
      'type': 'object',
      'properties': {
        'directory': {
          'type': 'string',
          'description': 'Directory to search (relative or absolute).',
        },
        'query': {
          'type': 'string',
          'description': 'Text to search for.',
        },
        'maxResults': {
          'type': 'number',
          'description': 'Maximum number of documents to return.',
          'default': 5,
        },
      },
      'required': ['directory', 'query'],
    },
    handler: (args) async {
      final dirPath = args['directory'] as String;
      final query = (args['query'] as String).toLowerCase();
      final maxResults = (args['maxResults'] as num? ?? 5).toInt(); // simple coercion

      final dir = Directory(dirPath);
      if (!dir.existsSync()) {
        return CallToolResult(
          content: [
            TextContent(
              text: 'Directory not found: $dirPath',
            ),
          ],
          isError: true,
        );
      }

      final buffer = StringBuffer()
        ..writeln('Search results for "$query" in "$dirPath":')
        ..writeln();

      var foundDocs = 0;

      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (foundDocs >= maxResults) {
          break;
        }

        if (entity is File && (entity.path.endsWith('.txt') || entity.path.endsWith('.md'))) {
          final content = await entity.readAsString();
          final lower = content.toLowerCase();
          final index = lower.indexOf(query);
          if (index != -1) {
            foundDocs++;
            // Get a short excerpt around the match
            final start = index - 80 > 0 ? index - 80 : 0;
            final end = (index + query.length + 80 < content.length) ? index + query.length + 80 : content.length;
            final excerpt = content.substring(start, end).replaceAll('\n', ' ');

            buffer
              ..writeln('--- File: ${entity.path}')
              ..writeln('...${excerpt.trim()}...')
              ..writeln();
          }
        }
      }

      if (foundDocs == 0) {
        buffer.writeln('No matches found.');
      }

      return CallToolResult(
        content: [TextContent(text: buffer.toString())],
      );
    },
  );
}

/// Tool 2: summarize
///
/// Input:
/// {
///   "text": "very long text ...",
///   "maxSentences": 3
/// }
///
/// Output: crude summary (first N sentences).
void _registerSummarizeTool(Server server) {
  server.addTool(
    name: 'summarize',
    description: 'Summarize plain text. (Demo implementation: takes first N sentences.)',
    inputSchema: {
      'type': 'object',
      'properties': {
        'text': {
          'type': 'string',
          'description': 'Text to summarize.',
        },
        'maxSentences': {
          'type': 'number',
          'description': 'Maximum number of sentences in the summary.',
          'default': 3,
        },
      },
      'required': ['text'],
    },
    handler: (args) async {
      final text = args['text'] as String;
      final maxSentences = (args['maxSentences'] as num? ?? 3).toInt();

      // Very naive summarization: split by '.', take first N sentences.
      final sentences = text.split(RegExp('[.!?]+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

      final summarySentences = sentences.take(maxSentences).join('. ') + (sentences.isNotEmpty ? '.' : '');

      return CallToolResult(
        content: [TextContent(text: summarySentences)],
      );
    },
  );
}

/// Tool 3: save_to_file
///
/// Input:
/// {
///   "path": "output/summary.txt",
///   "content": "summary text ..."
/// }
void _registerSaveToFileTool(Server server) {
  server.addTool(
    name: 'save_to_file',
    description: 'Save text content to a file on disk.',
    inputSchema: {
      'type': 'object',
      'properties': {
        'path': {
          'type': 'string',
          'description': 'File path to write to.',
        },
        'content': {
          'type': 'string',
          'description': 'Text content to save.',
        },
      },
      'required': ['path', 'content'],
    },
    handler: (args) async {
      final path = args['path'] as String;
      final content = args['content'] as String;

      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsString(content);

      return CallToolResult(
        content: [TextContent(text: 'Saved content to "$path" (${content.length} chars).')],
      );
    },
  );
}

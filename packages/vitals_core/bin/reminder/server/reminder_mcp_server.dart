// bin/reminder_mcp_server.dart
import 'dart:convert';

import 'package:mcp_server/mcp_server.dart'; // adjust to actual API
import 'package:uuid/uuid.dart';
import '../data/reminder_store.dart';

const _uuid = Uuid();

Future<void> main(List<String> args) async {
  final store = ReminderStore('reminders.json');

  final server = Server(
    name: 'reminder-server',
    version: '1.0.0',
    capabilities: ServerCapabilities.simple(tools: true, resources: true, logging: true),
  )

    // Tool: reminder/add
    ..addTool(
      name: 'reminder_add',
      description: 'Add a reminder/task.',
      inputSchema: {
        'type': 'object',
        'properties': {
          'title': {'type': 'string'},
          'description': {'type': 'string'},
          'dueAt': {
            'type': ['string', 'null'],
            'format': 'date-time',
          },
        },
        'required': ['title'],
      },
      handler: (arg) async {
        final title = arg['title'] as String;
        final description = arg['description'] as String?;
        final dueAtStr = arg['dueAt'] as String?;
        final dueAt = dueAtStr != null ? DateTime.parse(dueAtStr).toUtc() : null;

        final reminder = Reminder(
          id: _uuid.v4(),
          title: title,
          description: description,
          dueAt: dueAt,
        );

        final saved = await store.add(reminder);

        return CallToolResult(content: [TextContent(text: saved.id)]);
      },
    )

    // Tool: reminder/list
    ..addTool(
      name: 'reminder_list',
      description: 'List all reminders (optionally filter by done/overdue).',
      inputSchema: {
        'type': 'object',
        'properties': {
          'includeDone': {'type': 'boolean'},
        },
      },
      handler: (arg) async {
        final includeDone = arg['includeDone'] as bool? ?? false;
        final list = await store.listAll();
        final filtered = includeDone ? list : list.where((r) => !r.done).toList();

        return CallToolResult(
          content: [
            ...filtered.map((r) => TextContent(text: jsonEncode(r.toJson()))),
          ],
        );
      },
    )

    // Tool: reminder/summary
    ..addTool(
      name: 'reminder_summary',
      description: 'Return a structured summary: overdue, due today, upcoming, done counts.',
      inputSchema: {
        'type': 'object',
        'properties': {},
      },
      handler: (arg) async {
        final now = DateTime.now().toUtc();
        final today = DateTime.utc(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));

        final all = await store.listAll();

        final overdue = <Map<String, dynamic>>[];
        final todayList = <Map<String, dynamic>>[];
        final upcoming = <Map<String, dynamic>>[];

        for (final r in all.where((r) => !r.done && r.dueAt != null)) {
          final due = r.dueAt!;
          if (due.isBefore(today)) {
            overdue.add(r.toJson());
          } else if (!due.isBefore(today) && due.isBefore(tomorrow)) {
            todayList.add(r.toJson());
          } else {
            upcoming.add(r.toJson());
          }
        }

        final doneCount = all.where((r) => r.done).length;

        return CallToolResult(
          content: [
            TextContent(
              text: jsonEncode({
                'overdue': overdue,
                'today': todayList,
                'upcoming': upcoming,
                'stats': {
                  'total': all.length,
                  'done': doneCount,
                  'pending': all.length - doneCount,
                },
              }),
            ),
          ],
        );
      },
    )

    // Tool: reminder/mark_done
    ..addTool(
      name: 'reminder_mark_done',
      description: 'Mark a reminder as done by id.',
      inputSchema: {
        'type': 'object',
        'properties': {
          'id': {'type': 'string'},
        },
        'required': ['id'],
      },
      handler: (arg) async {
        final id = arg['id'] as String;
        await store.markDone(id);
        return {'ok': true};
      },
    );

  // Connect server to stdio transport for MCP hosts
  final transportResult = McpServer.createTransport(
    const TransportConfig.sse(),
  );
  final transport = await transportResult.get();
  //final transportResult = McpServer.createStdioTransport();
  //final transport = transportResult.get();
  server.connect(transport);
}

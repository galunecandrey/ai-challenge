// lib/reminder_store.dart
import 'dart:convert';
import 'dart:io';

class Reminder {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final bool done;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    this.dueAt,
    this.done = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  Reminder copyWith({bool? done}) => Reminder(
        id: id,
        title: title,
        description: description,
        dueAt: dueAt,
        done: done ?? this.done,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueAt': dueAt?.toIso8601String(),
        'done': done,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        dueAt: json['dueAt'] != null ? DateTime.parse(json['dueAt'] as String) : null,
        done: json['done'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ReminderStore {
  final File file;

  ReminderStore(String path) : file = File(path);

  Future<List<Reminder>> _load() async {
    if (!file.existsSync()) {
      return [];
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return [];
    }
    final raw = jsonDecode(content) as List<dynamic>;
    return raw.map((e) => Reminder.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _save(List<Reminder> reminders) async {
    final jsonList = reminders.map((r) => r.toJson()).toList();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(jsonList),
    );
  }

  Future<List<Reminder>> listAll() => _load();

  Future<Reminder> add(Reminder reminder) async {
    final list = await _load();
    list.add(reminder);
    await _save(list);
    return reminder;
  }

  Future<void> markDone(String id) async {
    final list = await _load();
    final idx = list.indexWhere((r) => r.id == id);
    if (idx == -1) {
      return;
    }
    list[idx] = list[idx].copyWith(done: true);
    await _save(list);
  }
}

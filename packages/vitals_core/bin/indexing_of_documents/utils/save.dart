import 'dart:convert' show JsonEncoder;
import 'dart:io' show File;

import '../data/models.dart';

Future<void> saveIndexToJsonFile(EmbeddingIndex index, String path) async {
  final file = File(path);
  final jsonString = const JsonEncoder.withIndent('  ').convert(index.toJson());
  await file.writeAsString(jsonString);
}
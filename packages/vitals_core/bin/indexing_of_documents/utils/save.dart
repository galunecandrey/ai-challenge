import 'dart:convert' show JsonEncoder;
import 'dart:io' show File;

import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';

Future<void> saveIndexToJsonFile(List<EmbeddingRecord> index, String path) async {
  final file = File(path);
  final jsonString = const JsonEncoder.withIndent('  ').convert(index.map((v) => v.toJson()).toList());
  await file.writeAsString(jsonString);
}

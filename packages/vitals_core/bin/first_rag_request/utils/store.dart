import 'dart:convert' show jsonDecode;
import 'dart:io' show File;

import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';

Future<List<EmbeddingRecord>> loadIndexFromJsonFile(String path) async {
  final file = File(path);
  final jsonString = await file.readAsString();
  final map = (jsonDecode(jsonString) as List).cast<Map<String, dynamic>>();
  return map.map(EmbeddingRecord.fromJson).toList();
}

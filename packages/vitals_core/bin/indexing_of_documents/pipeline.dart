import 'dart:io' show Directory, File;

import './utils/index.dart';
import './utils/save.dart';

Future<void> main(List<String> arguments) async {
  // For demonstration: read all .txt files in ./docs
  final docsDir = Directory('docs');
  final docs = <String, String>{};

  if (docsDir.existsSync()) {
    await for (final entity in docsDir.list(recursive: true)) {
      if (entity is File &&
          (entity.path.endsWith('.txt') || entity.path.endsWith('.md') || entity.path.endsWith('.dart'))) {
        final id = entity.uri.pathSegments.last; // filename
        final text = await entity.readAsString();
        docs[id] = text;
      }
    }
  } else {
    print('No docs directory found. Create ./docs with some .txt files.');
    return;
  }

  final index = await buildIndexFromDocuments(
    docs,
    apiKey: arguments[0],
  );

  await saveIndexToJsonFile(index, 'output/embedding_index.json');
  print('Index with ${index.records.length} embeddings saved to embedding_index.json');
}

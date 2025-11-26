//ignore_for_file: avoid_print
import 'dart:io' show Process;

import 'package:openai_dart/openai_dart.dart' show OpenAIClient;

import './utils/ai.dart';
import './utils/store.dart';

Future<void> main(List<String> arguments) async {
  print('Start create embedding_index.json pipeline');
  final process = await Process.start(
    'dart',
    [
      'bin/indexing_of_documents/pipeline.dart',
      arguments[0],
    ],
  );
  // Wait for finish
  final exitCode = await process.exitCode;
  print('End create embedding_index.json pipeline with exit code: $exitCode');

  final client = OpenAIClient(
    apiKey: arguments[0],
  );

  try {
    final records = await loadIndexFromJsonFile('output/embedding_index.json');

    const question = 'Key Components';

    await compareRagAndNonRag(
      client: client,
      records: records,
      question: question,
      chatModel: 'gpt-5-mini', // or 'gpt-4o-mini', etc.
    );
  } finally {
    // Close the underlying HTTP client session
    client.endSession();
  }
}

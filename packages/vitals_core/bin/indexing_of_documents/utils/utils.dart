import '../data/models.dart';

/// Naive "tokenizer": split by whitespace.
/// Replace with a real tokenizer if you need accurate token counts.
List<String> fakeTokenize(String text) {
  final result = text.split(RegExp(r'\s+')).where((t) => t.trim().isNotEmpty).toList();
  print('fakeTokenize: ${result.length}');
  return result;
}

/// Join tokens back into a string.
String detokenize(List<String> tokens) => tokens.join(' ');

List<DocumentChunk> chunkDocument({
  required String documentId,
  required String text,
  int maxTokens = 256,
  int overlapTokens = 50,
}) {
  final tokens = fakeTokenize(text);
  final chunks = <DocumentChunk>[];

  if (tokens.isEmpty) {
    return chunks;
  }

  var chunkIndex = 0;
  var start = 0;

  while (start < tokens.length) {
    final end = (start + maxTokens).clamp(0, tokens.length);
    final chunkTokens = tokens.sublist(start, end);
    final chunkText = detokenize(chunkTokens);

    final id = '$documentId::$chunkIndex';

    chunks.add(
      DocumentChunk(
        id: id,
        documentId: documentId,
        chunkIndex: chunkIndex,
        text: chunkText,
      ),
    );

    // Move start with overlap.
    if (end == tokens.length) {
      break;
    }
    start = end - overlapTokens;
    if (start < 0) {
      start = 0;
    }

    chunkIndex++;
  }

  return chunks;
}

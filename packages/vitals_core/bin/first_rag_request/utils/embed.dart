import 'package:openai_dart/openai_dart.dart' show CreateEmbeddingRequest, EmbeddingInput, EmbeddingModel, EmbeddingX, OpenAIClient;

Future<List<double>> embedQuestion({
  required OpenAIClient client,
  required String question,
  required String embeddingModel,
}) async {
  final res = await client.createEmbedding(
    request: CreateEmbeddingRequest(
      model: EmbeddingModel.modelId(embeddingModel),
      input: EmbeddingInput.string(question),
    ),
  );

  // `embeddingVector` is the typed field in openai_dart
  final vector = res.data.first.embeddingVector;
  return vector;
}

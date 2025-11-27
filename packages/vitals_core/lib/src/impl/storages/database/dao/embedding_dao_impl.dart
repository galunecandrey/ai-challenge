import 'dart:convert' show json;
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/storage/base/base_realm_storage.dart' show BaseRealmStorage;
import 'package:vitals_core/src/api/storage/database/dao/embedding_dao.dart';
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';
import 'package:vitals_core/src/model/entities/embedding/embedding_entity.dart';
import 'package:vitals_core/src/utils/const/dao.dart' show DaoClasses;
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: EmbeddingDao)
final class EmbeddingDaoImpl extends BaseRealmStorage<EmbeddingRecord, EmbeddingEntity> implements EmbeddingDao {
  EmbeddingDaoImpl({
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.operationService,
    @Named('isTestMode') super.isTest,
  }) : super(
          name: DaoClasses.kMessages,
        );

  @override
  EmbeddingRecord mapFromEntity(EmbeddingEntity data) => data.toModel;

  @override
  EmbeddingEntity mapToEntity(EmbeddingRecord data) => data.toEntity;

  @override
  String getModelId(EmbeddingRecord data) => data.chunkId;

  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must have same length');
    }
    double dot = 0;
    double normA = 0;
    double normB = 0;

    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) {
      return 0;
    }
    return dot / (math.sqrt(normA) * math.sqrt(normB));
  }

  double _scorePair(List<String> queryTokens, String document, CorpusStats corpusStats) {
    final docTokens = tokenizeToList(document);
    if (docTokens.isEmpty) return 0.0;

    // term frequency по документу
    final tf = <String, int>{};
    for (final t in docTokens) {
      tf[t] = (tf[t] ?? 0) + 1;
    }

    // Небольшая BM25-подобная нормализация по длине документа
    const k1 = 1.5;
    const b = 0.75;
    final docLen = docTokens.length.toDouble();
    final avgdl = corpusStats.avgDocLength == 0 ? 1.0 : corpusStats.avgDocLength;

    var score = 0.0;

    for (final qt in queryTokens) {
      final idf = corpusStats.idf[qt];
      if (idf == null) {
        continue; // слова нет в корпусе
      }

      final tfDoc = tf[qt] ?? 0;
      if (tfDoc == 0) {
        continue;
      }

      final tfNorm = (tfDoc * (k1 + 1)) / (tfDoc + k1 * (1 - b + b * (docLen / avgdl)));

      score += idf * tfNorm;
    }

    return score;
  }

  @override
  Future<Either<BaseError, List<EmbeddingRecord>>> topKRelevantChunks({
    required String query,
    required List<double> queryEmbedding,
    int topK = 15,
    double threshold = 0.1,
    int? topN,
  }) =>
      isEmpty().then((v) async {
        if (v.getOrElse(() => true)) {
          await operationService.safeAsyncOp(() => _loadJsonData());
        }
        return getAll().then(
          (v) => v.fold(
            (l) => left(l),
            (records) => operationService.safeSyncOp(
              () {
                if ((topN ?? 0) > topK) {
                  throw ArgumentError('topN must be <= topK');
                }
                return _topKRelevantChunks(
                  records: records,
                  queryEmbedding: queryEmbedding,
                  topK: topK,
                  threshold: threshold,
                ).let((v) {
                  info('_topKRelevantChunks: ${v.map((v) => v.chunkId)}');
                  if (topN != null) {
                    final result = _topNRelevantChunks(query: query, records: v, topN: topN);
                    info('_topNRelevantChunks: ${result.map((v) => v.chunkId)}');
                    return result;
                  }
                  return v;
                });
              },
            ),
          ),
        );
      });

  List<EmbeddingRecord> _topKRelevantChunks({
    required List<EmbeddingRecord> records,
    required List<double> queryEmbedding,
    int topK = 15,
    double threshold = 0.1,
  }) {
    final scored = <(EmbeddingRecord, double)>[];

    for (final rec in records) {
      final score = _cosineSimilarity(queryEmbedding, rec.embedding);
      scored.add((rec, score));
    }

    info('Bi-Encoder result: ${scored.map((v) => '${v.$1.chunkId} : ${v.$2}')}');

    final result = scored
        .filter((v) => v.$2 >= threshold)
        .sorted((a, b) => b.$2.compareTo(a.$2))
        .take(topK)
        .map((e) => e.$1)
        .toList();
    return result;
  }

  List<EmbeddingRecord> _topNRelevantChunks({
    required String query,
    required List<EmbeddingRecord> records,
    required int topN,
  }) {
    final scored = <(EmbeddingRecord, double)>[];
    final corpusStats = buildCorpusStats(records);

    final queryTokens = tokenizeToList(query);

    for (final rec in records) {
      final score = _scorePair(queryTokens, rec.text, corpusStats);
      scored.add((rec, score));
    }
    info('CrossEncoder result: ${scored.map((v) => '${v.$1.chunkId} : ${v.$2}')}');
    final result = scored.sorted((a, b) => b.$2.compareTo(a.$2)).take(topN).map((e) => e.$1).toList();
    return result;
  }

  Future<dynamic> _loadJsonData() async {
    info('Start load embedding_index.json from assets');
    // Load the JSON file as a string
    final jsonString = await rootBundle.loadString('assets/json/embedding_index.json');

    // Decode the JSON string into a Dart object
    final dynamic data = json.decode(jsonString);

    info('Success load embedding_index.json from assets');

    final records = (data as List).cast<Map<String, dynamic>>().map(EmbeddingRecord.fromJson).toList();

    await addAll(records);

    return data;
  }
}

class CorpusStats {
  final Map<String, double> idf; // term -> idf
  final double avgDocLength; // средняя длина документа в токенах

  CorpusStats({
    required this.idf,
    required this.avgDocLength,
  });
}

CorpusStats buildCorpusStats(List<EmbeddingRecord> chunks) {
  final df = <String, int>{}; // document frequency
  int docCount = chunks.length;
  int totalLength = 0;

  for (final chunk in chunks) {
    final tokens = tokenizeToList(chunk.text);
    totalLength += tokens.length;
    final uniqueTokens = tokens.toSet();

    for (final t in uniqueTokens) {
      df[t] = (df[t] ?? 0) + 1;
    }
  }

  final idf = <String, double>{};
  const epsilon = 1e-10;

  df.forEach((term, docFreq) {
    // Простая IDF: log( (N + 1) / (df + 1) ) + 1
    final value = math.log((docCount + 1) / (docFreq + 1 + epsilon)) + 1;
    idf[term] = value;
  });

  final avgDocLength = docCount == 0 ? 0.0 : totalLength.toDouble() / docCount.toDouble();

  return CorpusStats(idf: idf, avgDocLength: avgDocLength);
}

// Простая токенизация: приводим к нижнему регистру, убираем мусор, делим по пробелам.
Set<String> tokenizeToSet(String text) => text
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9а-яёієїґ]+', caseSensitive: false), ' ')
    .split(RegExp(r'\s+'))
    .where((t) => t.isNotEmpty)
    .toSet();

List<String> tokenizeToList(String text) => text
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9а-яёієїґ]+', caseSensitive: false), ' ')
    .split(RegExp(r'\s+'))
    .where((t) => t.isNotEmpty)
    .toList();

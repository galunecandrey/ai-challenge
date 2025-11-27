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

  @override
  Future<Either<BaseError, List<EmbeddingRecord>>> topKRelevantChunks({
    required List<double> queryEmbedding,
    int topK = 4,
  }) =>
      isEmpty().then((v) async {
        if (v.getOrElse(() => true)) {
          await operationService.safeAsyncOp(() => _loadJsonData());
        }
        return getAll().then(
          (v) => v.fold(
            (l) => left(l),
            (records) => operationService.safeSyncOp(
              () => _topKRelevantChunks(
                records: records,
                queryEmbedding: queryEmbedding,
              ),
            ),
          ),
        );
      });

  List<EmbeddingRecord> _topKRelevantChunks({
    required List<EmbeddingRecord> records,
    required List<double> queryEmbedding,
    int topK = 4,
  }) {
    final scored = <(EmbeddingRecord, double)>[];

    for (final rec in records) {
      final score = _cosineSimilarity(queryEmbedding, rec.embedding);
      scored.add((rec, score));
    }

    scored.sort((a, b) => b.$2.compareTo(a.$2)); // descending by score

    return scored.take(topK).map((e) => e.$1).toList();
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

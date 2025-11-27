import 'package:vitals_core/src/api/storage/database/dao/base/base_dao.dart' show BaseDao;
import 'package:vitals_core/src/api/storage/database/dao/base/query_dao.dart' show QueryDao;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either;

abstract interface class EmbeddingDao implements BaseDao<EmbeddingRecord>, QueryDao<EmbeddingRecord> {
  Future<Either<BaseError, List<EmbeddingRecord>>> topKRelevantChunks({
    required String query,
    required List<double> queryEmbedding,
    int topK = 15,
    double threshold = 0.1,
    int? topN,
  });
}

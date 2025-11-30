import 'package:realm/realm.dart';
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart';

part 'embedding_entity.realm.dart';

@RealmModel()
class _EmbeddingEntity {
  @MapTo('_id')
  @PrimaryKey()
  late String chunkId;
  late List<double> embedding;
  late String documentId;
  late int chunkIndex;
  late String text;
  late String model;
  late String uri;
}

extension EmbeddingEntityExt on EmbeddingEntity {
  EmbeddingRecord get toModel => EmbeddingRecord(
        chunkId: chunkId,
        embedding: embedding.toList(),
        documentId: documentId,
        chunkIndex: chunkIndex,
        text: text,
        model: model,
        uri: uri,
      );
}

import 'package:vitals_core/src/api/storage/base/base_box_storage.dart' show BaseBoxStorage;

final class BasePartCombinedDao<T> extends BaseBoxStorage<T> {
  final String Function(T data) _getBoxKey;

  BasePartCombinedDao({
    required super.name,
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.operationService,
    required super.isTest,
    required super.initName,
    required super.version,
    required String Function(T data) getBoxKey,
    super.secureKey,
  }) : _getBoxKey = getBoxKey;

  @override
  String getBoxKey(T data) => _getBoxKey(data);
}

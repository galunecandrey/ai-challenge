import 'package:vitals_core/src/api/storage/base/base_box_key_storage.dart' show BaseBoxKeyStorage;

final class CombinedKeyStorage extends BaseBoxKeyStorage<String> {
  CombinedKeyStorage({
    required String name,
    required super.dbProvider,
    required super.secureKeyStorage,
    required super.operationService,
    required super.version,
    super.isTest,
    super.secureKey,
    super.initName,
  }) : super(name: '${name}_key_storage');
}

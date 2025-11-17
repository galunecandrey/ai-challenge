import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/storage/memory/memory_key_storage.dart' show MemoryKeyStorage;
import 'package:vitals_utils/vitals_utils.dart' show BaseError, Either, Unit;

@lazySingleton
base class SecureKeyStorage extends MemoryKeyStorage<String, String> {
  SecureKeyStorage(super.operationService);

  @disposeMethod
  @override
  Either<BaseError, Unit> close() => super.close();
}

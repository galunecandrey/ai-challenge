import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/ai/ai_agent.dart';
import 'package:vitals_core/src/api/storage/memory/memory_key_storage.dart';
import 'package:vitals_utils/vitals_utils.dart';

@lazySingleton
base class AIAgentStorage extends MemoryKeyStorage<String, AIAgent> {
  AIAgentStorage(super.operationService);

  @disposeMethod
  @override
  Either<BaseError, Unit> close() => super.close();
}

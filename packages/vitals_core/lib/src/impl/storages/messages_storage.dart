import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/storage/memory/memory_storage.dart';
import 'package:vitals_core/src/model/message/message.dart';
import 'package:vitals_utils/vitals_utils.dart';

@lazySingleton
base class MessagesStorage extends MemoryStorage<List<Message>> {
  MessagesStorage(super.operationService) : super(initialValue: List.unmodifiable([]));

  @disposeMethod
  @override
  Future<Either<BaseError, Unit>> close() => super.close();
}

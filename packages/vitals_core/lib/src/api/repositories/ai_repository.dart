import 'package:vitals_core/src/model/message/message.dart' show Message;
import 'package:vitals_utils/vitals_utils.dart';

abstract interface class AIRepository {
  Future<Either<BaseError, Unit>> sendText(String text);

  Either<BaseError, List<Message>> get history;

  Stream<Either<BaseError, List<Message>>> getHistoryStream({bool sendFirst = false});

  Either<BaseError, Unit> clearHistory();
}

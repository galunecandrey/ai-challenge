import 'package:vitals_core/src/model/ai_agent_options/ai_agent_options.dart';
import 'package:vitals_core/src/model/message/message.dart';
import 'package:vitals_utils/vitals_utils.dart';

abstract interface class AIAgent implements Disposable {
  void updateSystemPrompt(String prompt);

  void removeSystemPrompt();

  Future<Either<BaseError, Message>> sendRequest(
    String text, {
    double? temperature,
    bool isKeepContext = true,
  });

  AIAgentOptions get options;

  Stream<AIAgentOptions> getOptionsStream({bool sendFirst = false});

  List<Message> get context;

  Stream<List<Message>> getContextStream({bool sendFirst = false});

  void clearContext();
}

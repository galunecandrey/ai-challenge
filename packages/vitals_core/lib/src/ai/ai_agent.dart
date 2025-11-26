import 'package:vitals_core/src/ai/ai_mcp_client.dart';
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/model/message/message.dart';
import 'package:vitals_utils/vitals_utils.dart';

abstract interface class AIAgent implements Disposable {
  void addMCPClient(AiMcpClient client);

  void updateSystemPrompt(String prompt);

  void removeSystemPrompt();

  Future<Either<BaseError, Message>> sendRequest(
    String text, {
    double? temperature,
    bool isKeepContext = true,
    bool useRAG = false,
  });

  AISession get options;

  Stream<AISession> getOptionsStream({bool sendFirst = false});

  List<Message> get context;

  Stream<List<Message>> getContextStream({bool sendFirst = false});

  void clearContext();
}

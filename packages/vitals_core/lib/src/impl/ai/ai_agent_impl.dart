import 'package:openai_dart/openai_dart.dart'
    show
        ChatCompletionMessage,
        ChatCompletionModel,
        ChatCompletionUserMessageContent,
        CreateChatCompletionRequest,
        OpenAIClient;
import 'package:vitals_core/src/ai/ai_agent.dart' show AIAgent;
import 'package:vitals_core/src/api/providers/date_time_provider.dart' show DateTimeProvider;
import 'package:vitals_core/src/model/ai_agent_options/ai_agent_options.dart' show AIAgentOptions;
import 'package:vitals_core/src/model/message/message.dart' show Message, MessageExt, MessageRoles;
import 'package:vitals_core/src/model/message/usage_data.dart';
import 'package:vitals_utils/vitals_utils.dart';

final class AIAgentImpl extends Disposable implements AIAgent {
  AIAgentImpl(
    AIAgentOptions options,
    this._client,
    this._operationService,
    this._dateTimeProvider,
  ) {
    _options.add(options);
  }

  late final _options = stateOf<AIAgentOptions>();
  final OpenAIClient _client;
  final OperationService _operationService;
  late final _context = stateOf<List<Message>>(List.unmodifiable([]));
  final DateTimeProvider _dateTimeProvider;

  @override
  void updateSystemPrompt(String prompt) {
    _options.add(_options.value.copyWith(systemPrompt: prompt));
  }

  @override
  void removeSystemPrompt() {
    _options.add(_options.value.copyWith(systemPrompt: null));
  }

  @override
  Future<Either<BaseError, Message>> sendRequest(
    String text, {
    double? temperature,
    bool isKeepContext = true,
  }) {
    info('Temperature: $temperature\nisKeepContext: $isKeepContext\nRequest:$text');
    _context.add(
      List.unmodifiable([
        Message(
          id: _dateTimeProvider.current.millisecondsSinceEpoch,
          role: MessageRoles.user,
          text: text,
        ),
        ..._context.value,
      ]),
    );
    final stopwatch = Stopwatch()..start();
    return _operationService
        .safeAsyncOp(
      () => _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(_options.value.model),
          temperature: temperature,
          messages: [
            if (_options.value.systemPrompt != null)
              ChatCompletionMessage.system(
                content: _options.value.systemPrompt!,
              ),
            if (isKeepContext) ..._context.value.map((m) => m.toChatCompletionMessage),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(text),
            ),
          ],
        ),
      ),
    )
        .then((result) {
      stopwatch.stop();
      info(result.toString());
      return result.map((r) {
        final result = r.choices.first.let(
          (it) => Message(
            id: _dateTimeProvider.current.millisecondsSinceEpoch,
            role: MessageRoles.assistant,
            text: it.message.content.orEmpty,
            usage: r.usage?.let(
              (it) => UsageData(
                requestTokens: it.promptTokens,
                responseTokens: it.completionTokens,
                totalTokens: it.totalTokens,
                time: stopwatch.elapsed,
              ),
            ),
            // data: _operationService
            //     .safeSyncOp(
            //       () => MessageData.fromJson(
            //         jsonDecode(it.message.content.orEmpty) as Map<String, dynamic>,
            //       ),
            //     )
            //     .fold(
            //       (l) => null,
            //       (r) => r,
            //     ),
          ),
        );
        _context.add(
          List.unmodifiable([
            result,
            ..._context.value,
          ]),
        );
        return result;
      });
    });
  }

  @override
  AIAgentOptions get options => _options.value;

  @override
  Stream<AIAgentOptions> getOptionsStream({bool sendFirst = false}) => _options(sendFirst: sendFirst);

  @override
  List<Message> get context => _context.value;

  @override
  Stream<List<Message>> getContextStream({bool sendFirst = false}) => _context(sendFirst: sendFirst);

  @override
  void clearContext() => _context.add(List.unmodifiable([]));
}

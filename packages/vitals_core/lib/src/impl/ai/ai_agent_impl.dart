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
import 'package:vitals_core/src/utils/const/prompts.dart';
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
    final latest = Message(
      id: _dateTimeProvider.current.millisecondsSinceEpoch,
      role: MessageRoles.user,
      text: text,
    );
    _context.add(
      List.unmodifiable([
        latest,
        ..._context.value,
      ]),
    );
    final stopwatch = Stopwatch()..start();
    return _summarizer(
      List<Message>.unmodifiable([..._context.value]),
      latest,
    ).then(
      (r) => _operationService
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
      }),
    );
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

  Future<void> _summarizer(
    List<Message> messages,
    Message latest,
  ) async {
    if (messages.filter((r) => r.role != MessageRoles.system).length <= 5) {
      return;
    }
    info('Start compression');
    final stopwatch = Stopwatch()..start();
    await _operationService
        .safeAsyncOp(
      () => _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(_options.value.model),
          messages: [
            ..._context.value.map((m) => m.toChatCompletionMessage),
            const ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(kSystemCompression),
            ),
          ],
        ),
      ),
    )
        .then((result) {
      info('Compression result: $result');
      stopwatch.stop();
      return result.map((r) {
        final result = r.choices.first.let(
          (it) => Message(
            id: _dateTimeProvider.current.millisecondsSinceEpoch,
            role: MessageRoles.system,
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
            latest,
            result,
          ]),
        );
        return result;
      });
    });
  }
}

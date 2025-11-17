//ignore_for_file: close_sinks
import 'package:ksuid/ksuid.dart';
import 'package:openai_dart/openai_dart.dart'
    show
        ChatCompletionMessage,
        ChatCompletionModel,
        ChatCompletionUserMessageContent,
        CreateChatCompletionRequest,
        OpenAIClient;
import 'package:vitals_core/src/ai/ai_agent.dart' show AIAgent;
import 'package:vitals_core/src/api/providers/date_time_provider.dart' show DateTimeProvider;
import 'package:vitals_core/src/api/storage/database/database.dart';
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/model/message/message.dart' show Message, MessageExt, MessageRoles;
import 'package:vitals_core/src/model/message/usage_data.dart';
import 'package:vitals_core/src/utils/const/prompts.dart';
import 'package:vitals_core/src/utils/const/query_fields.dart' show kUnixTimeFieldName;
import 'package:vitals_utils/vitals_utils.dart';

final class AIAgentImpl extends Disposable implements AIAgent {
  AIAgentImpl(
    AISession options,
    this._client,
    this._operationService,
    this._dateTimeProvider,
    this._database,
  ) {
    _options.add(options);
    _database.session.streamById(options.key, sendFirst: true).listen((data) {
      data.forEach(_options.add);
    });
    _database.messages
        .streamQuery(
      "sessionKey == '${options.key}' AND isCompressed == false SORT($kUnixTimeFieldName DESC)",
      sendFirst: true,
    )
        .listen((data) {
      data.forEach(_context.add);
    });
  }

  late final _options = stateOf<AISession>();
  final Database _database;
  final OpenAIClient _client;
  final OperationService _operationService;
  late final _context = stateOf<List<Message>>(List.unmodifiable([]));
  final DateTimeProvider _dateTimeProvider;

  Future<Either<BaseError, AIAgent>> init() => _database.session.containsId(options.key).then((result) {
        if (!result.getOrElse(() => false)) {
          _database.session.add(options);
        }
        return right(this);
      });

  @override
  void updateSystemPrompt(String prompt) {
    _database.session.add(_options.value.copyWith(systemPrompt: prompt));
  }

  @override
  void removeSystemPrompt() {
    _database.session.add(_options.value.copyWith(systemPrompt: null));
  }

  @override
  Future<Either<BaseError, Message>> sendRequest(
    String text, {
    double? temperature,
    bool isKeepContext = true,
  }) {
    info('Temperature: $temperature\nisKeepContext: $isKeepContext\nRequest:$text');
    final current = _dateTimeProvider.current;
    final latest = Message(
      id: KSUID.generate(date: current).asString,
      role: MessageRoles.user,
      text: text,
      unixTime: current.millisecondsSinceEpoch,
      sessionKey: options.key,
    );
    _database.messages.add(latest);
    final stopwatch = Stopwatch();
    return _summarizer(latest).then(
      (r) => _operationService.safeAsyncOp(() async {
        final history = (await _database.messages.query(
                "_id != '${latest.id}' AND sessionKey == '${options.key}' AND isActive == true  SORT($kUnixTimeFieldName ASC)"))
            .getOrElse(() => List<Message>.unmodifiable([]));
        info('Start request');
        stopwatch.start();
        return _client.createChatCompletion(
          request: CreateChatCompletionRequest(
            model: ChatCompletionModel.modelId(_options.value.model),
            temperature: temperature,
            messages: [
              if (_options.value.systemPrompt != null)
                ChatCompletionMessage.system(
                  content: _options.value.systemPrompt!,
                ),
              if (isKeepContext) ...history.map((m) => m.toChatCompletionMessage),
              ChatCompletionMessage.user(
                content: ChatCompletionUserMessageContent.string(text),
              ),
            ],
          ),
        );
      }).then((result) {
        stopwatch.stop();
        info(result.toString());
        return result.map((r) {
          final current = _dateTimeProvider.current;
          final result = r.choices.first.let(
            (it) => Message(
              id: KSUID.generate(date: current).asString,
              role: MessageRoles.assistant,
              text: it.message.content.orEmpty,
              unixTime: current.millisecondsSinceEpoch,
              sessionKey: options.key,
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
          _database.messages.add(result);
          return result;
        });
      }),
    );
  }

  @override
  AISession get options => _options.value;

  @override
  Stream<AISession> getOptionsStream({bool sendFirst = false}) => _options(sendFirst: sendFirst);

  @override
  List<Message> get context => _context.value;

  @override
  Stream<List<Message>> getContextStream({bool sendFirst = false}) => _context(sendFirst: sendFirst);

  @override
  void clearContext() => _database.messages.deleteQuery("sessionKey == '${options.key}'");

  Future<void> _summarizer(
    Message latest,
  ) async {
    final history = (await _database.messages.query(
            "_id != '${latest.id}' AND sessionKey == '${options.key}' AND isActive == true  SORT($kUnixTimeFieldName ASC)"))
        .getOrElse(() => List<Message>.unmodifiable([]));
    if (history.length < 50) {
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
            ...history.map((m) => m.toChatCompletionMessage),
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
        final current = _dateTimeProvider.current;
        final result = r.choices.first.let(
          (it) => Message(
            id: KSUID.generate(date: current).asString,
            role: MessageRoles.system,
            text: it.message.content.orEmpty,
            sessionKey: options.key,
            usage: r.usage?.let(
              (it) => UsageData(
                requestTokens: it.promptTokens,
                responseTokens: it.completionTokens,
                totalTokens: it.totalTokens,
                time: stopwatch.elapsed,
              ),
            ),
            unixTime: history.maxBy((r) => r.unixTime)!.unixTime,
            isCompressed: true,
          ),
        );
        _database.messages.addAll(
          List.unmodifiable([
            history.map((r) => r.copyWith(isActive: false)),
            result,
          ]),
        );
        return result;
      });
    });
  }
}

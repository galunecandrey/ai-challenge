//ignore_for_file: close_sinks
import 'dart:convert';

import 'package:ksuid/ksuid.dart';
import 'package:openai_dart/openai_dart.dart'
    show
        ChatCompletionFinishReason,
        ChatCompletionMessage,
        ChatCompletionMessageToolCall,
        ChatCompletionModel,
        ChatCompletionToolChoiceMode,
        ChatCompletionToolChoiceOption,
        ChatCompletionUserMessageContent,
        CreateChatCompletionRequest,
        CreateChatCompletionResponse,
        OpenAIClient;
import 'package:vitals_core/src/ai/ai_agent.dart' show AIAgent;
import 'package:vitals_core/src/ai/ai_mcp_client.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart' show DateTimeProvider;
import 'package:vitals_core/src/api/storage/database/database.dart';
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/model/message/message.dart' show Message, MessageExt, MessageRoles;
import 'package:vitals_core/src/model/message/usage_data.dart';
import 'package:vitals_core/src/utils/const/prompts.dart';
import 'package:vitals_core/src/utils/const/query_fields.dart' show kUnixTimeFieldName;
import 'package:vitals_core/src/utils/extensions/ai_extensions.dart';
import 'package:vitals_utils/vitals_utils.dart';

final class AIAgentImpl extends Disposable implements AIAgent {
  AIAgentImpl(
    AISession options,
    this._client,
    this._operationService,
    this._dateTimeProvider,
    this._database,
    this._mcpClient,
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
  final AiMcpClient _mcpClient;
  final Database _database;
  final OpenAIClient _client;
  final OperationService _operationService;
  late final _context = stateOf<List<Message>>(List.unmodifiable([]));
  final DateTimeProvider _dateTimeProvider;
  final stopwatch = Stopwatch();

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
  }) async {
    info('Temperature: $temperature\nisKeepContext: $isKeepContext\nRequest:$text');
    final current = _dateTimeProvider.current;
    final latest = Message(
      id: KSUID.generate(date: current).asString,
      role: MessageRoles.user,
      text: text,
      unixTime: current.millisecondsSinceEpoch,
      sessionKey: options.key,
    );
    await _database.messages.add(latest);
    final request = await _getRequest(
      text,
      latest.id,
      temperature: temperature,
      isKeepContext: isKeepContext,
    );
    return _summarizer(latest).then(
      (r) => _operationService.safeAsyncOp(() {
        info('Start request');
        stopwatch
          ..reset()
          ..start();
        return _client.createChatCompletion(
          request: request,
        );
      }).then((result) {
        stopwatch
          ..stop()
          ..reset();
        info(result.toString());
        return result.fold(
          (l) async => left(l),
          (r) async {
            final choice = r.choices.first;
            return (choice.finishReason == ChatCompletionFinishReason.toolCalls
                    ? _functionCall(request, choice.message.toolCalls!.first)
                    : Future<Either<BaseError, CreateChatCompletionResponse>>.value(right(r)))
                .then(
              (v) => v.fold(
                (l) async => left(l),
                (r) {
                  final result = _getMessage(r);
                  _database.messages.add(result);
                  return right(result);
                },
              ),
            );
          },
        );
      }),
    );
  }

  Future<CreateChatCompletionRequest> _getRequest(
    String text,
    String latestId, {
    double? temperature,
    bool isKeepContext = true,
  }) async {
    final history = (await _database.messages.query(
      "_id != '$latestId' AND sessionKey == '${options.key}' AND isActive == true  SORT($kUnixTimeFieldName ASC)",
    ))
        .getOrElse(() => List<Message>.unmodifiable([]));

    final tools = await _mcpClient.listTools().then(
          (v) => v
              .getOrElse(() => [])
              .map(
                (e) => e.toFunctionObject.toChatCompletionTool,
              )
              .toList(),
        );
    return CreateChatCompletionRequest(
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
      tools: tools,
      //toolChoice: const ChatCompletionToolChoiceOption.mode(ChatCompletionToolChoiceMode.auto),
    );
  }

  Message _getMessage(CreateChatCompletionResponse response) {
    final choice = response.choices.first;
    final current = _dateTimeProvider.current;
    return choice.let(
      (it) => Message(
        id: KSUID.generate(date: current).asString,
        role: MessageRoles.assistant,
        text: it.message.content.orEmpty,
        unixTime: current.millisecondsSinceEpoch,
        sessionKey: options.key,
        usage: response.usage?.let(
          (it) => UsageData(
            requestTokens: it.promptTokens,
            responseTokens: it.completionTokens,
            totalTokens: it.totalTokens,
            time: stopwatch.elapsed,
          ),
        ),
      ),
    );
  }

  Future<Either<BaseError, CreateChatCompletionResponse>> _functionCall(
    CreateChatCompletionRequest request,
    ChatCompletionMessageToolCall toolCall,
  ) {
    info('functionCall');
    return _mcpClient
        .callTool(
          toolCall.function.name,
          jsonDecode(toolCall.function.arguments) as Map<String, dynamic>,
        )
        .then(
          (v) => v.fold(
            (l) async => left(l),
            (r) {
              info('callTool result: ${r.toJson()}');
              return _operationService
                  .safeAsyncOp(
                () => _client.createChatCompletion(
                  request: request.copyWith(
                    messages: [
                      ...request.messages,
                      ChatCompletionMessage.assistant(
                        toolCalls: [
                          toolCall,
                        ],
                      ),
                      ChatCompletionMessage.tool(
                        toolCallId: toolCall.id,
                        content: json.encode(r.toJson()),
                      ),
                    ],
                  ),
                ),
              )
                  .then((v) {
                info('Response with tool result: $v');
                return v;
              });
            },
          ),
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
    stopwatch
      ..reset()
      ..start();
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
      stopwatch
        ..reset()
        ..stop();
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

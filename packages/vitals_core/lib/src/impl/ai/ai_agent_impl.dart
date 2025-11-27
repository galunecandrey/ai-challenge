//ignore_for_file: close_sinks
import 'dart:convert';

import 'package:ksuid/ksuid.dart';
import 'package:mcp_client/mcp_client.dart' show TextContent;
import 'package:openai_dart/openai_dart.dart'
    show
        ChatCompletionFinishReason,
        ChatCompletionMessage,
        ChatCompletionMessageToolCall,
        ChatCompletionModel,
        ChatCompletionUserMessageContent,
        CreateChatCompletionRequest,
        CreateChatCompletionResponse,
        CreateEmbeddingRequest,
        EmbeddingInput,
        EmbeddingModel,
        EmbeddingX,
        OpenAIClient;
import 'package:vitals_core/src/ai/ai_agent.dart' show AIAgent;
import 'package:vitals_core/src/ai/ai_mcp_client.dart';
import 'package:vitals_core/src/api/providers/date_time_provider.dart' show DateTimeProvider;
import 'package:vitals_core/src/api/storage/database/database.dart';
import 'package:vitals_core/src/model/ai_session/ai_session.dart' show AISession;
import 'package:vitals_core/src/model/embedding/record/embedding_record.dart' show EmbeddingRecord;
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
  ) {
    _options.add(options);
    _database.session.streamById(options.key, sendFirst: true).listen((data) {
      data.forEach(_options.add);
    }).cancelable(cancelable);
    _database.messages
        .streamQuery(
      "sessionKey == '${options.key}' AND isCompressed == false SORT($kUnixTimeFieldName DESC)",
      sendFirst: true,
    )
        .listen((data) {
      data.forEach(_context.add);
    }).cancelable(cancelable);
    // Stream.periodic(const Duration(minutes: 3)).listen((v) {
    //   runPlannerTick();
    // }).cancelable(cancelable);
    _init();
  }

  late final _options = stateOf<AISession>();
  late final _mcpClients = stateOf<List<AiMcpClient>>(List.unmodifiable([]));
  final Database _database;
  final OpenAIClient _client;
  final OperationService _operationService;
  late final _context = stateOf<List<Message>>(List.unmodifiable([]));
  final DateTimeProvider _dateTimeProvider;
  final stopwatch = Stopwatch();

  Future<Either<BaseError, AIAgent>> _init() => _database.session.containsId(options.key).then((result) {
        if (!result.getOrElse(() => false)) {
          _database.session.add(options);
        }
        return right(this);
      });

  Future<Either<BaseError, Message>> runPlannerTick() async =>
      _mcpClients.value.find((v) => v.isContainsTool('reminder_summary'))!.callTool(
        'reminder_summary',
        {},
      ).then(
        (summaryResult) => summaryResult.fold(
          (l) async => left(l),
          (summary) {
            final userPrompt = '''
Here is the current reminder summary JSON:

${(summary.content.first as TextContent).text}

Please:
1. Produce a natural-language summary for the user (max ~10 bullet points).
2. Suggest the top 3 things they should focus on next.
3. If something is overdue or due soon, consider calling MCP tools to:
   - mark them done (if it makes sense), or
   - create follow-up reminders.
''';
            info('Summary prompt: $userPrompt');
            return _operationService
                .safeAsyncOp(
                  () => _client.createChatCompletion(
                    request: CreateChatCompletionRequest(
                      model: ChatCompletionModel.modelId(_options.value.model),
                      messages: [
                        ChatCompletionMessage.user(
                          content: ChatCompletionUserMessageContent.string(userPrompt),
                        ),
                      ],
                      //toolChoice: const ChatCompletionToolChoiceOption.mode(ChatCompletionToolChoiceMode.auto),
                    ),
                  ),
                )
                .then(
                  (resultSummary) => resultSummary.fold((l) async => left(l), (r) {
                    final message = _getMessage(r, title: '--- PLANNER SUMMARY ---');
                    _database.messages.add(message.copyWith(isActive: false));
                    return right(message);
                  }),
                );
          },
        ),
      );

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
    bool useRAG = false,
    int ragTopK = 15,
    double ragThreshold = 0.1,
    int? ragTopN,
  }) async {
    info('Temperature: $temperature\nisKeepContext: $isKeepContext\nRequest:$text\nuseRAG: $useRAG');
    final current = _dateTimeProvider.current;
    final latest = Message(
      id: KSUID.generate(date: current).asString,
      role: MessageRoles.user,
      text: text,
      unixTime: current.millisecondsSinceEpoch,
      sessionKey: options.key,
    );
    await _database.messages.add(latest);
    final request = await (useRAG
        ? _getRAGRequest(
            text,
            latest.id,
            temperature: temperature,
            isKeepContext: isKeepContext,
            ragThreshold: ragThreshold,
            ragTopK: ragTopK,
            ragTopN: ragTopN,
          )
        : _getRequest(
            text,
            latest.id,
            temperature: temperature,
            isKeepContext: isKeepContext,
          ));
    return _summarizer(latest).then(
      (r) => _operationService.safeAsyncOp(() {
        info('Start chat completion request: $request');
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
        info('Chat completion request result: $result');
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

  Future<CreateChatCompletionRequest> _getRAGRequest(
    String text,
    String latestId, {
    double? temperature,
    bool isKeepContext = true,
    int ragTopK = 15,
    double ragThreshold = 0.1,
    int? ragTopN,
  }) async {
    final response = await _client.createEmbedding(
      request: CreateEmbeddingRequest(
        model: const EmbeddingModel.modelId('text-embedding-3-small'),
        input: EmbeddingInput.string(text),
      ),
    );

    final records = await _database.embedding
        .topKRelevantChunks(
          query: text,
          queryEmbedding: response.data.first.embeddingVector,
          topK: ragTopK,
          threshold: ragThreshold,
          topN: ragTopN,
        )
        .then((v) => v.getOrElse(() => []));

    final history = (await _database.messages.query(
      "_id != '$latestId' AND sessionKey == '${options.key}' AND isActive == true  SORT($kUnixTimeFieldName ASC)",
    ))
        .getOrElse(() => List<Message>.unmodifiable([]));

    final tools = await Future.wait([
      for (final mcp in _mcpClients.value)
        mcp.listTools().then(
              (v) => v
                  .getOrElse(() => [])
                  .map(
                    (e) => e.toFunctionObject.toChatCompletionTool,
                  )
                  .toList(),
            ),
    ]).then(
      (v) => [
        for (final list in v) ...list,
      ],
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
        ..._buildRagMessages(question: text, context: _buildContextFromChunks(records)),
      ],
      tools: tools,
      //toolChoice: const ChatCompletionToolChoiceOption.mode(ChatCompletionToolChoiceMode.auto),
    );
  }

  String _buildContextFromChunks(List<EmbeddingRecord> chunks) {
    final buffer = StringBuffer()
      ..writeln('You are an AI assistant that answers ONLY based on the context chunks provided below.')
      ..writeln()
      ..writeln('REQUIREMENTS:')
      ..writeln('1. Your answer must be in pure Markdown.')
      ..writeln(
          '2. When using information from a chunk, you MUST cite it using its sourceId in square brackets, for example: [S1], [S3].')
      ..writeln('3. At the end of the answer you MUST add a section:')
      ..writeln('   ### Sources:')
      ..writeln('   - [S<index of source>] <source title> ( <url> )')
      ..writeln('   - [S<index of source>] <source title> ( <url> )')
      ..writeln('4. If the answer cannot be derived from the provided chunks, say:')
      ..writeln('   "I cannot answer based on the provided sources."')
      ..writeln('5. Do NOT invent facts that are not present in the context.')
      ..writeln('6. Do NOT include any JSON in the answer.')
      ..writeln('7. Do NOT mention that you are citing sources — simply cite them.')
      ..writeln()
      ..writeln('ANSWER STRUCTURE (MANDATORY):')
      ..writeln('### Answer:')
      ..writeln('<your Markdown answer with citations like [S1], [S2]>')
      ..writeln()
      ..writeln('### Sources:')
      ..writeln('- [S1] Title ( URL )')
      ..writeln('- [S2] Title ( URL )')
      ..writeln()
      ..writeln('---')
      ..writeln('Below are the available context chunks. Each chunk has: sourceId, title, url, text.')
      ..writeln();

    for (final chunk in chunks) {
      buffer
        ..writeln('sourceId: ${chunk.chunkId}')
        ..writeln('title: ${chunk.documentId}')
        ..writeln('url: ${chunk.uri}')
        ..writeln('text: """')
        ..writeln(chunk.text)
        ..writeln('"""')
        ..writeln('---')
        ..writeln();
    }

    return buffer.toString();
  }

  List<ChatCompletionMessage> _buildRagMessages({
    required String question,
    required String context,
  }) =>
      [
        ChatCompletionMessage.system(
          content: context,
        ),
        ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(question),
        ),
      ];

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

    final tools = await Future.wait([
      for (final mcp in _mcpClients.value)
        mcp.listTools().then(
              (v) => v
                  .getOrElse(() => [])
                  .map(
                    (e) => e.toFunctionObject.toChatCompletionTool,
                  )
                  .toList(),
            ),
    ]).then(
      (v) => [
        for (final list in v) ...list,
      ],
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

  Message _getMessage(CreateChatCompletionResponse response, {String? title}) {
    final choice = response.choices.first;
    final current = _dateTimeProvider.current;
    return choice.let(
      (it) => Message(
        id: KSUID.generate(date: current).asString,
        role: MessageRoles.assistant,
        text: (title != null ? '$title\n' : '') + it.message.content.orEmpty,
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
    info('functionCall: ${toolCall.function.name} ${toolCall.function.arguments}');
    return _mcpClients.value
        .find((v) => v.isContainsTool(toolCall.function.name))!
        .callTool(
          toolCall.function.name,
          jsonDecode(toolCall.function.arguments) as Map<String, dynamic>,
        )
        .then(
          (v) => v.fold(
            (l) async => left(l),
            (r) {
              final newRequest = request.copyWith(
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
              );
              info('New chat completion request with tool result: $newRequest');
              return _operationService
                  .safeAsyncOp(
                () => _client.createChatCompletion(
                  request: newRequest,
                ),
              )
                  .then((v) {
                info('Response with tool result: $v');
                return v.fold((l) async => left(l), (r) {
                  final newChoice = r.choices.first;
                  return newChoice.finishReason == ChatCompletionFinishReason.toolCalls
                      ? _functionCall(newRequest, newChoice.message.toolCalls!.first)
                      : Future.value(right(r));
                });
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
      "_id != '${latest.id}' AND sessionKey == '${options.key}' AND isActive == true  SORT($kUnixTimeFieldName ASC)",
    ))
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

  @override
  void addMCPClient(AiMcpClient client) {
    _mcpClients.add(
      List.unmodifiable(
        [
          ..._mcpClients.value,
          client,
        ],
      ),
    );
  }
}

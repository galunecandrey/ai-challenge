import 'package:mcp_client/mcp_client.dart' show Tool;
import 'package:openai_dart/openai_dart.dart'
    show
        ChatCompletionFunctionCallOption,
        ChatCompletionNamedToolChoice,
        ChatCompletionNamedToolChoiceType,
        ChatCompletionTool,
        ChatCompletionToolChoiceOption,
        ChatCompletionToolType,
        FunctionObject;

extension ToolExt on Tool {
  FunctionObject get toFunctionObject => FunctionObject(
        name: name,
        description: description,
        parameters: inputSchema,
      );
}

extension FunctionObjectExt on FunctionObject {
  ChatCompletionTool get toChatCompletionTool => ChatCompletionTool(
        type: ChatCompletionToolType.function,
        function: this,
      );

  ChatCompletionToolChoiceOption get toChatCompletionToolChoiceOption => ChatCompletionToolChoiceOption.tool(
        ChatCompletionNamedToolChoice(
          type: ChatCompletionNamedToolChoiceType.function,
          function: ChatCompletionFunctionCallOption(name: name),
        ),
      );
}

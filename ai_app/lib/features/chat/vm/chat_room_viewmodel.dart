// ignore_for_file: close_sinks
import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart' show ViewModel;
import 'package:vitals_core/vitals_core.dart' show AIAgent, AIAgentOptions, AIAgentProvider;
import 'package:vitals_sdk_example/features/chat/model/message_item.dart' show MessageListItemModel;
import 'package:vitals_utils/vitals_utils.dart';

const kMaxQuickRepliesNumber = 6;

@injectable
class ChatRoomViewModel extends ViewModel {
  late AIAgent _agent;
  late final _isWaiting = stateOf<bool>(false);

  final double _temperature;

  bool get isWaiting => _isWaiting.value;

  Stream<bool> get isWaitingStream => _isWaiting(sendFirst: true);

  List<MessageListItemModel> get context => [
        if (isWaiting) const MessageListItemModel.waiting(),
        ..._agent.context.map((r) => MessageListItemModel.item(model: r)),
      ];

  Stream<List<MessageListItemModel>> getContextStream() => Rx.combineLatest2(
        _agent.getContextStream(sendFirst: true),
        _isWaiting(sendFirst: true),
        (list, isProgress) => [
          if (isProgress) const MessageListItemModel.waiting(),
          ...list.map((r) => MessageListItemModel.item(model: r)),
        ],
      );

  ChatRoomViewModel(
    AIAgentProvider provider,
    @factoryParam AIAgentOptions? options,
    @factoryParam double? temperature,
  ) : _temperature = temperature! {
    _agent = provider.get(options!);
  }

  void sendMessage(String text) {
    _isWaiting.add(true);
    _agent
        .sendRequest(
      text,
      temperature: _temperature,
      isKeepContext: false,
    )
        .then((v) {
      _isWaiting.add(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _agent.dispose();
  }
}

// ignore_for_file: close_sinks
import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart' show ViewModel;
import 'package:vitals_core/vitals_core.dart' show AIAgent, AIAgentProvider, AIAgentTypes, AISession;
import 'package:vitals_sdk_example/features/chat/model/message_item.dart' show MessageListItemModel;
import 'package:vitals_utils/vitals_utils.dart';

const kMaxQuickRepliesNumber = 6;

@injectable
class ChatRoomViewModel extends ViewModel {
  late AIAgent _agent;
  late final _isWaiting = stateOf<bool>(false);

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
    @factoryParam AISession? options,
    @factoryParam AIAgentTypes? type,
  ) {
    _agent = provider.get(options!, type: type!);
  }

  void sendMessage(String text) {
    _isWaiting.add(true);
    _agent
        .sendRequest(
      text,
      useRAG: true,
      ragTopN: 3,
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

// ignore_for_file: close_sinks
import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart' show ViewModel;
import 'package:vitals_core/vitals_core.dart' show AIAgents, AIRepository;
import 'package:vitals_sdk_example/features/home/model/message_item.dart';
import 'package:vitals_utils/vitals_utils.dart';

const kMaxQuickRepliesNumber = 6;

@injectable
class MessagesRoomViewModel extends ViewModel {
  final AIRepository _repository;

  late final _isWaiting = stateOf<bool>(false);

  bool get isWaiting => _isWaiting.value;

  Stream<bool> get isWaitingStream => _isWaiting(sendFirst: true);

  List<MessageListItemModel> getContextForAgent(AIAgents agent) => [
        if (isWaiting) const MessageListItemModel.waiting(),
        ..._repository.getAIAgentContext(agent).getOrElse(() => []).map((r) => MessageListItemModel.item(model: r)),
      ];

  Stream<List<MessageListItemModel>> getContextStreamForAgent(AIAgents agent) => Rx.combineLatest2(
        _repository.getAIAgentContextStream(agent, sendFirst: true).map((r) => r.getOrElse(() => [])),
        _isWaiting(sendFirst: true),
        (list, isProgress) => [
          if (isProgress) const MessageListItemModel.waiting(),
          ...list.map((r) => MessageListItemModel.item(model: r)),
        ],
      );

  MessagesRoomViewModel(this._repository);

  void sendMessage(String text) {
    _isWaiting.add(true);
    _repository.sendRequestToAll(text).then((v) {
      _isWaiting.add(false);
    });
  }
}

// ignore_for_file: close_sinks
import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart' show ViewModel;
import 'package:vitals_core/vitals_core.dart' show AIRepository, Message;
import 'package:vitals_sdk_example/features/home/model/message_item.dart';
import 'package:vitals_utils/vitals_utils.dart';

const kMaxQuickRepliesNumber = 6;

@injectable
class MessagesRoomViewModel extends ViewModel {
  final AIRepository _repository;

  late final _items = stateOf<List<Message>>(List.unmodifiable([]));

  late final _isWaiting = stateOf<bool>(false);

  bool get isWaiting => _isWaiting.value;

  Stream<bool> get isWaitingStream => _isWaiting(sendFirst: true);

  List<MessageListItemModel> get items => [
        if (isWaiting) const MessageListItemModel.waiting(),
        ..._items.value.map((r) => MessageListItemModel.item(model: r)),
      ];

  Stream<List<MessageListItemModel>> get itemsStream => Rx.combineLatest2(
        _items(sendFirst: true),
        _isWaiting(sendFirst: true),
        (list, isProgress) => [
          if (isProgress) const MessageListItemModel.waiting(),
          ...list.map((r) => MessageListItemModel.item(model: r)),
        ],
      );

  MessagesRoomViewModel(this._repository) {
    _repository.getHistoryStream(sendFirst: true).listen((r) {
      r.forEach(_items.add);
    }).cancelable(cancelable);
  }

  void sendMessage(String text) {
    _isWaiting.add(true);
    _repository.sendText(text).then((v) {
      _isWaiting.add(false);
    });
  }
}

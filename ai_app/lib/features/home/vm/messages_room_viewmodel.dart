// ignore_for_file: close_sinks
import 'package:injectable/injectable.dart';
import 'package:vitals_arch/vitals_arch.dart' show ViewModel;
import 'package:vitals_core/vitals_core.dart' show AIRepository, Message;
import 'package:vitals_utils/vitals_utils.dart';

const kMaxQuickRepliesNumber = 6;

@injectable
class MessagesRoomViewModel extends ViewModel {
  final AIRepository _repository;

  late final _items = stateOf<List<Message>>(List.unmodifiable([]));

  List<Message> get items => _items.value;

  Stream<List<Message>> get itemsStream => _items(sendFirst: true);

  MessagesRoomViewModel(this._repository) {
    _repository.getHistoryStream(sendFirst: true).listen((r) {
      r.forEach(_items.add);
    }).cancelable(cancelable);
  }

  void sendMessage(String text) => _repository.sendText(text);
}

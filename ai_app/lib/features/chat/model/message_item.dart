import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vitals_core/vitals_core.dart';

part 'message_item.freezed.dart';

@freezed
sealed class MessageListItemModel with _$MessageListItemModel {
  const factory MessageListItemModel.waiting() = MessageWaiting;

  const factory MessageListItemModel.item({
    required Message model,
  }) = MessageItem;
}

extension MessageListItemModelExt on MessageListItemModel {
  bool get isUser => switch (this) {
        MessageWaiting() => false,
        MessageItem(model: final data) => data.isUser,
      };
}

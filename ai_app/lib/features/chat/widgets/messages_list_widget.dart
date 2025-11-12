import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart' show DateTimeProvider;
import 'package:vitals_sdk_example/features/chat/model/message_item.dart';
import 'package:vitals_sdk_example/features/chat/vm/chat_room_viewmodel.dart' show ChatRoomViewModel;
import 'package:vitals_sdk_example/features/chat/widgets/message_card.dart';
import 'package:vitals_sdk_example/theme/theme.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ChatRoomViewModel>();
    final theme = AppTheme.theme().themeData;
    return SelectionArea(
      contextMenuBuilder: (context, state) => Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            brightness: Brightness.dark,
          ),
        ),
        child: AdaptiveTextSelectionToolbar.buttonItems(
          anchors: state.contextMenuAnchors,
          buttonItems: <ContextMenuButtonItem>[...state.contextMenuButtonItems],
        ),
      ),
      child: StreamBuilder<List<MessageListItemModel>>(
        initialData: vm.context,
        stream: vm.getContextStream(),
        builder: (context, messagesSnapshot) => StreamBuilder<DateTime>(
          stream: context
              .read<DateTimeProvider>()
              .getTimeChangedStream()
              .distinct((previous, next) => previous.timeZoneOffset != next.timeZoneOffset),
          initialData: context.read<DateTimeProvider>().current,
          builder: (context, timeSnapshot) => ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final message = messagesSnapshot.requireData[index];
              return MessageCard(
                message: message,
              );
            },
            itemCount: messagesSnapshot.requireData.length,
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}

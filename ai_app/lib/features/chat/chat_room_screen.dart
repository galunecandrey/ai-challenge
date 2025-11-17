import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart' show Binder, StatefulBindableWidget;
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/features/chat/vm/chat_room_viewmodel.dart' show ChatRoomViewModel;
import 'package:vitals_sdk_example/features/chat/widgets/messages_list_widget.dart' show MessagesListWidget;
import 'package:vitals_sdk_example/features/chat/widgets/send_message_bar_widget.dart' show SendMessageBarWidget;

class ChatRoomScreen extends Binder<ChatRoomViewModel> {
  const ChatRoomScreen({
    required AISession options,
    required AIAgentTypes type,
    super.key,
  }) : super(
          param1: options,
          param2: type,
        );

  @override
  StatefulBindableWidget<ChatRoomViewModel> buildWidget(BuildContext context) => const _ChatRoomWidget();
}

class _ChatRoomWidget extends StatefulBindableWidget<ChatRoomViewModel> {
  const _ChatRoomWidget({
    //ignore: unused_element
    super.key,
  });

  @override
  _ChatRoomWidgetState createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<_ChatRoomWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessagesListWidget(),
          ),
          SendMessageBarWidget(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

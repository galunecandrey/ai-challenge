import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart' show BindableWidget, Binder;
import 'package:vitals_sdk_example/features/home/vm/messages_room_viewmodel.dart' show MessagesRoomViewModel;
import 'package:vitals_sdk_example/features/home/widgets/messages_list_widget.dart';
import 'package:vitals_sdk_example/features/home/widgets/send_message_bar_widget.dart' show SendMessageBarWidget;

@RoutePage()
class MessagesRoomScreen extends Binder<MessagesRoomViewModel> {
  const MessagesRoomScreen({
    super.key,
  }) : super();

  @override
  BindableWidget<MessagesRoomViewModel> buildWidget(BuildContext context) => const _MessagesRoomWidget();
}

class _MessagesRoomWidget extends BindableWidget<MessagesRoomViewModel> {
  const _MessagesRoomWidget({
    //ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: const Column(
          children: [
            Expanded(
              child: MessagesListWidget(),
            ),
            SendMessageBarWidget(),
          ],
        ),
      );
}

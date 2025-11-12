import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/features/chat/model/message_item.dart';
import 'package:vitals_sdk_example/features/chat/widgets/waiting_widget.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/vis_theme_mode_enum.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    this.themeMode = VisThemeMode.light,
    super.key,
  });

  final MessageListItemModel message;
  final VisThemeMode themeMode;

  @override
  Widget build(BuildContext context) => Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: message.isUser ? 32 : 0, right: !message.isUser ? 32 : 0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: message.isUser
                ? AppColors.visionableCardBlue
                : AppColors.lightGray.withValues(alpha: themeMode == VisThemeMode.dark ? 0.15 : 1),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    switch (message) {
                      MessageWaiting() => const WaitingCallLabel(),
                      MessageItem(model: final data) => Text(
                          message.isUser || data.data == null
                              ? data.text
                              : 'Tag: ${data.data?.tag}\n'
                                  'Title: ${data.data?.title}\n'
                                  'Answer: ${data.data?.answer}\n'
                                  'Time: ${data.data?.time}',
                          style: TextStyle(
                            fontSize: 20,
                            color: message.isUser || themeMode == VisThemeMode.dark ? null : AppColors.black,
                          ),
                        ),
                    },
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

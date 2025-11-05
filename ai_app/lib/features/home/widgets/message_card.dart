import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/vis_theme_mode_enum.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    required this.message,
    this.themeMode = VisThemeMode.light,
    super.key,
  });

  final Message message;
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
                    Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 20,
                        color: message.isUser || themeMode == VisThemeMode.dark ? null : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

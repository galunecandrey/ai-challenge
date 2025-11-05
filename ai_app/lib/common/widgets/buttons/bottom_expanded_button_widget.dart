import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/common/widgets/buttons/vitals_button_widget.dart';
import 'package:vitals_sdk_example/theme/colors.dart';

class BottomExpandedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;

  const BottomExpandedButton({
    required this.onPressed,
    required this.text,
    this.color = AppColors.visionableMidBlue,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: onPressed == null ? AppColors.lightGray : color,
        child: SafeArea(
          child: VitalsButton(
            text: text,
            style: VitalsButtonStyle.bottomExpanded,
            onPressed: onPressed,
            color: color,
          ),
        ),
      );
}

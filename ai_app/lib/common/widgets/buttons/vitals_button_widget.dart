import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/common/localization/localizations.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

enum VitalsButtonStyle {
  bottomExpanded,
  expanded,
  fitToContent,
  fixedWidth,
}

class VitalsButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final String? textKey;
  final VitalsButtonStyle style;
  final BorderSide? borderStyle;
  final double? height;
  final double? width;
  final double? elevation;
  final TextStyle? textStyle;
  final Color color;
  final Widget? child;
  final EdgeInsetsGeometry? textPadding;

  const VitalsButton({
    this.text,
    this.textKey,
    this.onPressed,
    this.style = VitalsButtonStyle.fixedWidth,
    this.height,
    this.width,
    this.elevation,
    this.color = AppColors.visionableMidBlue,
    this.textStyle,
    this.borderStyle,
    this.textPadding,
    super.key,
  })  : child = null,
        assert(textKey != null || text != null);

  const VitalsButton.child({
    required this.onPressed,
    required Widget child,
    this.style = VitalsButtonStyle.fixedWidth,
    this.height,
    this.width,
    this.elevation,
    this.color = AppColors.visionableMidBlue,
    this.textStyle,
    this.borderStyle,
    this.textPadding,
    super.key,
  })  :
        //ignore: prefer_initializing_formals
        child = child,
        text = null,
        textKey = null;

  factory VitalsButton.submitReportButton({
    required VoidCallback onSubmit,
    VitalsButtonStyle style = VitalsButtonStyle.fixedWidth,
  }) =>
      VitalsButton(
        textKey: CommonTranslationKeys.kGlobalBtnSubmit,
        onPressed: onSubmit,
        style: style,
      );

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: textPadding != null ? WidgetStateProperty.all(textPadding) : null,
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.disabled) ? AppColors.lightGray : color,
          ),
          foregroundColor: WidgetStateProperty.all(AppColors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: borderStyle ?? BorderSide.none,
              borderRadius: style == VitalsButtonStyle.bottomExpanded ? BorderRadius.zero : BorderRadius.circular(4),
            ),
          ),
          elevation: WidgetStateProperty.all(elevation ?? 0),
          maximumSize: WidgetStateProperty.all(Size(maxWidth, maxMinHeight)),
          minimumSize: WidgetStateProperty.all(Size(minWidth, maxMinHeight)),
          fixedSize: WidgetStateProperty.all(Size.fromHeight(maxMinHeight)),
        ),
        child: child ??
            Text(
              text ??
                  context.translate(
                    textKey!,
                  ),
              style: textStyle ??
                  (style == VitalsButtonStyle.bottomExpanded
                      ? TextStyles.styles().boldWhite18
                      : TextStyles.styles().boldWhite16),
              textAlign: TextAlign.center,
              // overflow: TextOverflow.ellipsis,
            ),
      );

  double get minWidth {
    switch (style) {
      case VitalsButtonStyle.bottomExpanded:
      case VitalsButtonStyle.expanded:
        return double.infinity;
      case VitalsButtonStyle.fitToContent:
        return 0;
      case VitalsButtonStyle.fixedWidth:
        return width ?? 300;
    }
  }

  double get maxWidth => style == VitalsButtonStyle.fixedWidth ? width ?? 300 : double.infinity;

  double get maxMinHeight => height ?? (style == VitalsButtonStyle.bottomExpanded ? 55 : 45);
}

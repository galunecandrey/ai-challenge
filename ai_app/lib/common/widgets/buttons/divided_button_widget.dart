import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/common/enum/vitals_theme_mode.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

enum DividedButtonStyle { outlined, plain }

enum DividedButtonState { enabled, disabled, activated, error }

extension DividedButtonStateExtension on DividedButtonState {
  T resolve<T>({
    required T enabled,
    required T disabled,
    T? error,
    T? activated,
  }) {
    switch (this) {
      case DividedButtonState.enabled:
        return enabled;
      case DividedButtonState.disabled:
        return disabled;
      case DividedButtonState.activated:
        return activated ?? enabled;
      case DividedButtonState.error:
        return error ?? enabled;
    }
  }
}

class DividedButton<T> extends StatelessWidget {
  final bool isIconVisible;
  final String Function(T)? itemDescriptor;
  final Stream<T?>? selectedItemDataStream;
  final T? initialValue;
  final DividedButtonState state;
  final FlexFit fit;
  final DividedButtonStyle style;
  final double height;
  final double? width;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? child;
  final VitalsThemeMode themeMode;
  final IconData? trailingIcon;
  final double trailingIconSize;
  final Function()? onClearFieldClicked;

  const DividedButton({
    required this.selectedItemDataStream,
    required this.itemDescriptor,
    required this.initialValue,
    this.state = DividedButtonState.enabled,
    this.fit = FlexFit.tight,
    this.style = DividedButtonStyle.outlined,
    this.isIconVisible = false,
    this.height = 32,
    this.width,
    this.textStyle,
    this.icon,
    this.iconColor,
    this.child,
    this.themeMode = VitalsThemeMode.light,
    this.trailingIcon,
    this.trailingIconSize = 24,
    this.onClearFieldClicked,
    super.key,
  }) : assert(selectedItemDataStream != null || itemDescriptor != null);

  const DividedButton.child({
    required this.child,
    this.initialValue,
    this.state = DividedButtonState.enabled,
    this.fit = FlexFit.tight,
    this.style = DividedButtonStyle.outlined,
    this.isIconVisible = false,
    this.height = 50,
    this.width,
    this.textStyle,
    this.icon,
    this.iconColor,
    this.trailingIcon,
    this.themeMode = VitalsThemeMode.light,
    this.trailingIconSize = 10,
    this.onClearFieldClicked,
    super.key,
  })  : selectedItemDataStream = null,
        itemDescriptor = null;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        decoration: style == DividedButtonStyle.outlined
            ? BoxDecoration(
                color: themeMode == VitalsThemeMode.dark ? null : AppColors.white,
                border: Border.all(
                  color: state.resolve(
                    enabled: AppColors.lightGray,
                    disabled: themeMode.resolve(light: AppColors.lightGray, dark: AppColors.visionableBlueGrayBlended),
                    error: AppColors.red,
                    activated: AppColors.visionableMidBlue,
                  ),
                ),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        width: width,
        height: height,
        duration: const Duration(milliseconds: 300),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: height * 0.25),
            if (isIconVisible) ...[
              Icon(
                icon ?? Icons.check,
                color: iconColor ??
                    state.resolve(
                      enabled: themeMode.resolve(light: AppColors.visionableDarkBlue, dark: AppColors.white),
                      disabled:
                          themeMode.resolve(light: AppColors.lightGray, dark: AppColors.visionableBlueGrayBlended),
                    ),
                size: 22,
              ),
              const SizedBox(width: 8),
            ],
            if (child != null)
              Flexible(fit: fit, child: child!)
            else
              StreamBuilder<T?>(
                initialData: initialValue,
                stream: selectedItemDataStream,
                builder: (context, snapshot) => snapshot.hasData
                    ? Flexible(
                        fit: fit,
                        child: Text(
                          itemDescriptor!(snapshot.data as T),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: state.resolve(
                            enabled: textStyle ??
                                themeMode.resolve(
                                  light: TextStyles.styles().regularDarkBlue16,
                                  dark: TextStyles.styles().regularWhite16,
                                ),
                            disabled:
                                TextStyles.styles().regularWhite16.copyWith(color: AppColors.visionableBlueGrayBlended),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            if (onClearFieldClicked != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: onClearFieldClicked,
                  child: Icon(
                    Icons.clear,
                    size: 20,
                    color: iconColor ??
                        state.resolve(
                          enabled: themeMode.resolve(light: AppColors.visionableDarkBlue, dark: AppColors.white),
                          disabled:
                              themeMode.resolve(light: AppColors.lightGray, dark: AppColors.visionableBlueGrayBlended),
                          error: AppColors.red,
                        ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            SizedBox(
              height: height / 2,
              width: 1,
              child: VerticalDivider(
                thickness: 1,
                width: 1,
                color: state.resolve(
                  enabled: AppColors.lightGray,
                  disabled: themeMode.resolve(light: AppColors.lightGray, dark: AppColors.visionableBlueGrayBlended),
                  error: AppColors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(height * 0.18, 0, height * 0.18, 0),
              child: Icon(
                trailingIcon ?? Icons.keyboard_arrow_down,
                size: trailingIconSize,
                color: iconColor ??
                    state.resolve(
                      enabled: themeMode.resolve(light: AppColors.visionableDarkBlue, dark: AppColors.white),
                      disabled:
                          themeMode.resolve(light: AppColors.lightGray, dark: AppColors.visionableBlueGrayBlended),
                      error: AppColors.red,
                    ),
              ),
            ),
          ],
        ),
      );
}

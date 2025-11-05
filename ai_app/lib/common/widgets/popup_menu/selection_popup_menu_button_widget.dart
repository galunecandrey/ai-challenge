// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/common/enum/vitals_theme_mode.dart';
import 'package:vitals_sdk_example/common/widgets/popup_menu/popup_button_widget.dart';
import 'package:vitals_sdk_example/common/widgets/popup_menu/popup_menu_button_widget.dart' as popup;
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

enum PopupMenuStyle {
  outlined,
  flat,
}

extension PopupMenuStyleExtension on PopupMenuStyle {
  T resolve<T>({
    required T flat,
    required T outlined,
  }) {
    switch (this) {
      case PopupMenuStyle.flat:
        return flat;
      case PopupMenuStyle.outlined:
        return outlined;
    }
  }
}

typedef WidgetBuilder<T> = Widget Function(BuildContext context, T element, bool selected);

class SelectionPopupMenuButton<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T data, bool isMenuOpened) buttonBuilder;
  final List<T> items;
  final String Function(T) getItemDescriptor;
  final Stream<T>? Function()? getSelectedItemStream;
  final T? Function()? getInitialData;
  final Function(T) onChanged;
  final PopupMenuStyle menuStyle;
  final WidgetBuilder<T>? itemBuilder;
  final Widget? hint;
  final Widget? footer;
  final Widget? placeholder;
  final bool fitButtonWidth;
  final double? maxHeight;
  final Color popupBorderColor;
  final Offset offset;
  final PositionToShow positionToShow;
  final VitalsThemeMode themeMode;

  const SelectionPopupMenuButton({
    required this.buttonBuilder,
    required this.items,
    required this.getItemDescriptor,
    required this.getSelectedItemStream,
    required this.getInitialData,
    required this.onChanged,
    this.menuStyle = PopupMenuStyle.flat,
    this.itemBuilder,
    this.footer,
    this.placeholder,
    this.hint,
    this.fitButtonWidth = false,
    this.maxHeight,
    this.popupBorderColor = AppColors.visionableMidBlue,
    this.offset = const Offset(0, 2),
    this.positionToShow = PositionToShow.down,
    this.themeMode = VitalsThemeMode.light,
    super.key,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<T?>(
        stream: getSelectedItemStream?.call(),
        initialData: getInitialData?.call(),
        builder: (context, snapshot) => snapshot.hasData
            ? popup.PopupMenuButton<T>(
                initialValue: snapshot.data,
                fitButtonWidth: fitButtonWidth,
                maxHeight: maxHeight,
                color: themeMode.resolve(light: AppColors.white, dark: AppColors.visionableDarkBlue),
                elevation: menuStyle.resolve(flat: 8, outlined: 0),
                shape: menuStyle.resolve(
                  flat: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  outlined: OutlineInputBorder(borderSide: BorderSide(color: popupBorderColor)),
                ),
                offset: offset,
                positionToShow: positionToShow,
                onSelected: onChanged,
                itemBuilder: (context) => [
                  for (final element in items)
                    popup.PopupMenuItem(
                      height: 0,
                      padding: EdgeInsets.zero,
                      value: element,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                        decoration: snapshot.data == element
                            ? BoxDecoration(
                                color: menuStyle.resolve(
                                  flat: AppColors.visionableMidBlue.withOpacity(0.1),
                                  outlined: AppColors.lightestGray,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              )
                            : null,
                        child: itemBuilder?.call(context, element, snapshot.data == element) ??
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    getItemDescriptor(element),
                                    overflow: TextOverflow.clip,
                                    style: themeMode.resolve(
                                      light: TextStyles.styles().regularDarkBlue16,
                                      dark: TextStyles.styles().regularWhite16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 30,
                                  child: snapshot.data == element
                                      ? Icon(
                                          Icons.check,
                                          color: themeMode.resolve(
                                            light: AppColors.visionableDarkBlue,
                                            dark: AppColors.white,
                                          ),
                                          size: 20,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                      ),
                    ),
                  if (footer != null) popup.PopupMenuItem(height: 0, padding: EdgeInsets.zero, child: footer),
                ],
                buttonBuilder: (isMenuOpened) => snapshot.hasData
                    ? buttonBuilder(context, snapshot.data as T, isMenuOpened)
                    : hint ?? const SizedBox.shrink(),
              )
            : placeholder ?? const SizedBox.shrink(),
      );
}

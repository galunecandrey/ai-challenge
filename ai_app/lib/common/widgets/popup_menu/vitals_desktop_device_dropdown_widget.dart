import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/common/enum/vitals_theme_mode.dart';
import 'package:vitals_sdk_example/common/widgets/buttons/divided_button_widget.dart';
import 'package:vitals_sdk_example/common/widgets/conditional_parent/conditional_parent_widget.dart';
import 'package:vitals_sdk_example/common/widgets/popup_menu/selection_popup_menu_button_widget.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

class VitalsDesktopDeviceDropdown<T> extends StatelessWidget {
  final VitalsThemeMode themeMode;

  final List<T> items;
  final T? Function()? getSelectedData;
  final void Function(T) onChanged;
  final String Function(T) getItemDescription;
  final Stream<T> Function() getSelectedStream;
  final String? label;
  final CrossAxisAlignment lapelPosition;
  final TextStyle? labelStyle;

  const VitalsDesktopDeviceDropdown({
    required this.items,
    required this.getSelectedData,
    required this.onChanged,
    required this.getItemDescription,
    required this.getSelectedStream,
    this.themeMode = VitalsThemeMode.light,
    this.lapelPosition = CrossAxisAlignment.start,
    this.label,
    this.labelStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ConditionalParent(
        condition: label != null,
        parentBuilder: (child) => Column(
          crossAxisAlignment: lapelPosition,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  label!,
                  style: labelStyle ?? TextStyles.styles().boldWhite12,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            child,
          ],
        ),
        child: SelectionPopupMenuButton<T>(
          buttonBuilder: (context, duration, isMenuOpened) => DividedButton<T>(
            initialValue: getSelectedData?.call(),
            selectedItemDataStream: getSelectedStream(),
            itemDescriptor: (item) => getItemDescription(item),
            width: double.infinity,
            themeMode: themeMode,
          ),
          getInitialData: getSelectedData,
          getSelectedItemStream: getSelectedStream,
          getItemDescriptor: (item) => getItemDescription(item),
          items: items,
          onChanged: onChanged,
          themeMode: themeMode,
        ),
      );
}

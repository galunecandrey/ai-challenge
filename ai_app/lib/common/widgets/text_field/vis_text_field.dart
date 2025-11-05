import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DefaultSpellCheckService;
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart' show PlatformProvider;
import 'package:vitals_sdk_example/common/utils/ext/build_context_extension.dart';

class VisTextField extends StatelessWidget {
  final bool autofocus;
  final bool spellCheck;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextStyle? style;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool? isDense;
  final bool? filled;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;

  const VisTextField({
    this.autofocus = false,
    this.spellCheck = false,
    this.readOnly = false,
    this.controller,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.style,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.textInputAction,
    this.keyboardType,
    this.onSubmitted,
    this.maxLines,
    this.minLines,
    this.isDense,
    this.filled,
    this.contentPadding,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.errorBorder,
    this.disabledBorder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final platform = context.read<PlatformProvider>();
    return TextField(
      spellCheckConfiguration: spellCheck && !platform.isSamsung
          ? SpellCheckConfiguration(
        spellCheckService: DefaultSpellCheckService(),
      )
          : null,
      onTapOutside: (_) => context.closeKeyboard(),
      autofocus: autofocus,
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly,
      style: style,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        isDense: isDense,
        filled: filled,
        contentPadding: contentPadding,
        border: border,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        errorBorder: errorBorder,
        disabledBorder: disabledBorder,
      ),
    );
  }
}

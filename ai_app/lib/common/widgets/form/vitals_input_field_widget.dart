import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/common/utils/ext/build_context_extension.dart';
import 'package:vitals_sdk_example/common/widgets/buttons/vitals_icon_button_widget.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

class VitalsInputField extends StatefulWidget {
  final TextInputType keyboardType;
  final String? fieldInfoText;
  final String? initialValue;
  final String? hintText;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validatorFunc;
  final TextStyle? titleTextStyle;
  final bool showVisibilitySuffixIcon;
  final bool isObscureText;
  final bool spellCheck;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Function(String)? onFieldChanged;
  final Function(String)? onFieldSubmitted;
  final double? maxWidth;
  final double? minWidth;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Key? fieldInfoKey;
  final Key? textFormFieldKey;
  final Key? suffixIconKey;
  final Iterable<String>? autofillHints;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? errorTextStyle;

  const VitalsInputField({
    this.fieldInfoText,
    this.initialValue,
    this.textEditingController,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.titleTextStyle,
    this.showVisibilitySuffixIcon = false,
    this.spellCheck = false,
    this.validatorFunc,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onFieldChanged,
    this.onFieldSubmitted,
    this.minWidth,
    this.maxWidth,
    this.textInputAction,
    this.contentPadding,
    this.focusNode,
    this.inputFormatters,
    this.fieldInfoKey,
    this.textFormFieldKey,
    this.suffixIconKey,
    this.autofillHints,
    this.textStyle,
    this.hintTextStyle,
    this.errorTextStyle,
    super.key,
  });

  @override
  State<VitalsInputField> createState() => _VisInputFieldState();
}

class _VisInputFieldState extends State<VitalsInputField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: !context.read<PlatformProvider>().isMobile,
        stream: context.read<PlatformProvider>().stream((p) => !p.isMobile).distinct(),
        builder: (context, snapshot) {
          final platform = context.read<PlatformProvider>();
          return ConstrainedBox(
            constraints: _getBoxConstraints(snapshot.requireData),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.fieldInfoText != null)
                  Text(
                    widget.fieldInfoText!,
                    style: widget.titleTextStyle ?? TextStyles.styles().regularDarkBlue16,
                    textAlign: TextAlign.start,
                    key: widget.fieldInfoKey,
                  ),
                TextFormField(
                  spellCheckConfiguration: widget.spellCheck && !platform.isSamsung
                      ? SpellCheckConfiguration(
                          spellCheckService: DefaultSpellCheckService(),
                        )
                      : null,
                  onTapOutside: (_) => context.closeKeyboard(),
                  initialValue: widget.initialValue,
                  key: widget.textFormFieldKey,
                  focusNode: widget.focusNode,
                  minLines: widget.minLines ?? 1,
                  maxLines: widget.maxLines ?? 1,
                  maxLength: widget.maxLength,
                  keyboardType: widget.keyboardType,
                  obscureText: _isObscureText,
                  onChanged: widget.onFieldChanged,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  controller: widget.textEditingController,
                  validator: widget.validatorFunc,
                  inputFormatters: widget.inputFormatters,
                  style: widget.textStyle ?? TextStyles.styles().regularDarkBlue18,
                  textInputAction: widget.textInputAction,
                  decoration: InputDecoration(
                    counterStyle: TextStyles.styles().mediumLightGray14,
                    isDense: true,
                    suffixIcon: widget.showVisibilitySuffixIcon
                        ? VitalsIconButton(
                            key: widget.suffixIconKey,
                            icon: _isObscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            onPressed: () {
                              setState(() {
                                _isObscureText = !_isObscureText;
                              });
                            },
                          )
                        : null,
                    contentPadding: widget.contentPadding ??
                        EdgeInsets.fromLTRB(
                          20,
                          12,
                          widget.showVisibilitySuffixIcon || widget.maxLength != null ? 0 : 20,
                          12,
                        ),
                    hintStyle: widget.hintTextStyle ?? TextStyles.styles().regularLightGray18,
                    fillColor: AppColors.white,
                    filled: true,
                    errorStyle: widget.errorTextStyle ?? TextStyles.styles().semiBoldRed14,
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lightGray),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.visionableMidBlue),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                    hintText: widget.hintText,
                  ),
                  autofillHints: widget.autofillHints,
                ),
              ],
            ),
          );
        },
      );

  BoxConstraints _getBoxConstraints(bool isTablet) => isTablet
      ? BoxConstraints(minWidth: widget.minWidth ?? 500, maxWidth: widget.maxWidth ?? 600)
      : BoxConstraints(minWidth: widget.minWidth ?? 200, maxWidth: widget.maxWidth ?? 300);
}

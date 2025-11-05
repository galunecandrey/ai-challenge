import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart' as vf show PlatformProvider;
//import 'package:vitals_sdk_example/common/localization/localizations.dart' show BuildContextExt, CommonTranslationKeys;
import 'package:vitals_sdk_example/common/widgets/text_field/vis_text_field.dart' show VisTextField;
import 'package:vitals_sdk_example/features/home/vm/messages_room_viewmodel.dart' show MessagesRoomViewModel;
import 'package:vitals_sdk_example/theme/colors.dart' show AppColors;
import 'package:vitals_sdk_example/theme/text_styles.dart' show TextStyles;
import 'package:vitals_utils/vitals_utils.dart';

class SendMessageBarWidget extends StatefulWidget {
  const SendMessageBarWidget({super.key});

  @override
  State<SendMessageBarWidget> createState() => _SendMessageBarWidgetState();
}

class _SendMessageBarWidgetState extends State<SendMessageBarWidget> {
  late final _controller = TextEditingController();
  late final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final vm = context.read<MessagesRoomViewModel>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(
            color: AppColors.dividerGray,
          ),
        ),
      ),
      child: StreamBuilder<double>(
        initialData: context.read<vf.PlatformProvider>().mediaQueryData.padding.bottom,
        stream: context.read<vf.PlatformProvider>().stream((p) => p.mediaQueryData.padding.bottom).distinct(),
        builder: (context, snapshot) => Padding(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, bottom: context.read<vf.PlatformProvider>().isDesktop ? 0 : 2),
                  child: VisTextField(
                    spellCheck: true,
                    focusNode: _focusNode,
                    controller: _controller,
                    onChanged: (data) {},
                    hintText: 'Send',
                    hintStyle: TextStyles.styles().regularLightGray16,
                    style: TextStyles.styles().regularDarkBlue18,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    onSubmitted: (s) => _send(context, _controller.text),
                    maxLines: 12,
                    minLines: 1,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _send(context, _controller.text),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.send,
                  color: AppColors.visionableDarkBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _send(BuildContext context, String text) {
    if (text.isNotBlank) {
      context.read<MessagesRoomViewModel>().sendMessage(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }
}

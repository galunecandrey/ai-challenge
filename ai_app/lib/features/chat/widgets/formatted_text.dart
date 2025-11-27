import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart' show LinkCallback, Linkify;
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';

class FormattedText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final LinkCallback? onOpen;

  const FormattedText(
    this.data, {
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.onOpen,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Linkify(
        text: data,
        style: style,
        textAlign: textAlign,
        onOpen: onOpen ??
            (e) {
              context.read<LaunchService>().launch(Uri.file(e.url));
            },
        linkStyle: linkStyle,
      );
}

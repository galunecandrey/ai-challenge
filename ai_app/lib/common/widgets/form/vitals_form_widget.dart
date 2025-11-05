import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/common/widgets/conditional_parent/conditional_parent_widget.dart';

enum VitalsFormStyle { fillRemaining, simple, scrollable }

class VitalsForm extends StatelessWidget {
  final GlobalKey formKey;
  final double? maxWidth;
  final Widget child;
  final EdgeInsets padding;
  final VitalsFormStyle style;
  final bool isAutoFillGroup;

  const VitalsForm({
    required this.formKey,
    required this.child,
    this.maxWidth,
    this.style = VitalsFormStyle.scrollable,
    this.padding = const EdgeInsets.fromLTRB(38, 6, 38, 12),
    this.isAutoFillGroup = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final form = Padding(
      padding: padding,
      child: ConditionalParent(
        condition: isAutoFillGroup,
        parentBuilder: (child) => AutofillGroup(child: child),
        child: Form(
          key: formKey,
          child: StreamBuilder<bool>(
            initialData: !context.read<PlatformProvider>().isMobile,
            stream: context.read<PlatformProvider>().stream((p) => !p.isMobile).distinct(),
            builder: (context, snapshot) => Container(
              constraints: BoxConstraints(maxWidth: _getMaxWidth(snapshot.requireData)),
              child: child,
            ),
          ),
        ),
      ),
    );
    return switch (style) {
      VitalsFormStyle.fillRemaining => CustomScrollView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: form,
                  ),
                ],
              ),
            ),
          ],
        ),
      VitalsFormStyle.scrollable => SingleChildScrollView(child: Center(child: form)),
      VitalsFormStyle.simple => form,
    };
  }

  double _getMaxWidth(bool isTablet) => maxWidth ?? (isTablet ? 500 : 300);
}

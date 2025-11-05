import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

class VisBottomSheet extends StatelessWidget {
  final bool shrinkWrap;
  final String? headerText;
  final WidgetBuilder builder;
  final Color backgroundColor;
  final BorderRadius? shapeRadius;
  final PreferredSizeWidget? bottom;

  const VisBottomSheet({
    required this.shrinkWrap,
    required this.headerText,
    required this.builder,
    required this.backgroundColor,
    this.bottom,
    super.key,
    this.shapeRadius,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = shapeRadius ??
        const BorderRadius.vertical(
          top: Radius.circular(14),
        );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: CustomScrollView(
        shrinkWrap: shrinkWrap,
        physics: const BouncingScrollPhysics(),
        slivers: [
          if (headerText != null)
            SliverAppBar(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              pinned: true,
              centerTitle: true,
              backgroundColor: backgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.visionableDarkBlue,
                ),
                onPressed: Navigator.of(context).pop,
              ),
              title: Text(headerText!, style: TextStyles.styles().boldDarkBlue24),
              bottom: bottom,
            ),
          SliverToBoxAdapter(
            child: builder(context),
          ),
        ],
      ),
    );
  }
}

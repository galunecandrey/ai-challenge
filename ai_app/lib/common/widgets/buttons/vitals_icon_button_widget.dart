import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/theme/colors.dart';

class VitalsIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double? iconSize;
  final double splashRadius;
  final Color color;
  final BoxConstraints? constraints;
  final EdgeInsets padding;

  const VitalsIconButton({
    required this.icon,
    this.onPressed,
    this.iconSize = 22,
    this.splashRadius = 18,
    this.color = AppColors.visionableDarkBlue,
    this.constraints,
    this.padding = const EdgeInsets.all(8),
    super.key,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.transparent,
        child: IconButton(
          icon: Icon(icon),
          color: color,
          iconSize: iconSize,
          splashRadius: splashRadius,
          constraints: constraints,
          padding: padding,
          onPressed: onPressed,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VitalsLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const VitalsLogo({
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        'assets/vector_images/visionable_logo.svg',
        width: width,
        height: height,
      );
}

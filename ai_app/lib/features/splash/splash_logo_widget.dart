import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitals_sdk_example/common/localization/localizations.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 270);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: SizedBox(
          height: 96,
          width: _sizeTween.evaluate(animation),
          child: Hero(
            tag: 'login_logo',
            child: Text(
              context.translate(CommonTranslationKeys.kGlobalAppName),
              style: TextStyles.styles().boldWhiteLogo84,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

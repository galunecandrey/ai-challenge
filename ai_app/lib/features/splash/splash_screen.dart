import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_sdk_example/common/localization/localizations.dart';
import 'package:vitals_sdk_example/common/utils/vitals_system_tray_manager.dart';
import 'package:vitals_sdk_example/features/init/initializer.dart';
import 'package:vitals_sdk_example/features/splash/splash_logo_widget.dart';
import 'package:vitals_sdk_example/router/router.dart';
import 'package:vitals_sdk_example/theme/colors.dart';
import 'package:vitals_sdk_example/theme/text_styles.dart';

@RoutePage<void>()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _init(getIt<Initializer>());
  }

  Future<void> _init(Initializer init) => Future.wait<bool>(
        [
          if (!init.isCompleted) init.wait,
          Future.delayed(const Duration(seconds: 3), () => true),
        ],
      ).then((value) async {
        if (!init.isReady) {
          throw Exception();
        }
        getIt<VitalsSystemTrayManager>();
        unawaited(
          getIt<VitalsRouter>().replaceAll(
            [
              const HomeScreenRoute(),
            ],
          ),
        );
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) => Container(
            alignment: Alignment.center,
            color: AppColors.visionableBlue,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SplashLogo(),
                const SizedBox(
                  height: 16,
                ),
                if (snapshot.hasError)
                  Text(
                    context.translate(
                      CommonTranslationKeys.kGlobalErrorMsgInit,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyles.styles().boldRed18,
                  ),
              ],
            ),
          ),
        ),
      );
}

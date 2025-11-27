import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18next/i18next.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/common/localization/localizations.dart';
import 'package:vitals_sdk_example/router/context_provider.dart';
import 'package:vitals_sdk_example/router/vitals_router.dart';
import 'package:vitals_sdk_example/theme/theme.dart';

const double kMinKeyboardHeight = 50;

class VitalsSDKExampleApp extends StatelessWidget {
  const VitalsSDKExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(
            create: (context) => getIt<PlatformProvider>(),
          ),
          Provider(
            create: (context) => getIt<DateTimeProvider>(),
          ),
          Provider(
            create: (context) => getIt<LaunchService>(),
          ),
        ],
        child: MaterialApp.router(
          title: 'VitalsApp',
          debugShowCheckedModeBanner: false,
          // debugShowMaterialGrid: true,
          theme: AppTheme.theme().themeData,
          routerConfig: getIt<VitalsRouter>().config(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            I18NextLocalizationDelegate(
              locales: supportedLocales,
              dataSource: getIt<LocalizationDataSource>(),
              options: I18NextOptions(
                formatter: formatter,
                keySeparator: '..', // Use custom separator for nested types
                fallbackNamespaces: LocalizationNamespace.values.map((e) => e.stringValue).toList(),
              ),
            ),
          ],
          builder: (context, router) => Builder(
            builder: (ctx) {
              globalContext = ctx;
              return router!;
            },
          ),
        ),
      );
}

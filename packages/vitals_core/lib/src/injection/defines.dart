// ignore_for_file: do_not_use_environment

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:vitals_core/src/api/providers/platform_provider.dart';
import 'package:vitals_core/src/device/device_io.dart' as io;
import 'package:vitals_core/src/device/device_web.dart' as web;
import 'package:vitals_utils/vitals_utils.dart';

@module
abstract class Defines {
  @Named('shouldLog')
  @lazySingleton
  bool shouldLog({@Named('isTestMode') required bool isTestMode}) => kDebugMode && !isTestMode;

  @Named('isTestMode')
  @lazySingleton
  bool isTestMode(PlatformProvider provider) => provider.platformInfo.isTest;

  @lazySingleton
  PlatformInfo get platformInfo => kIsWeb ? web.platformInfo : io.platformInfo;

  @lazySingleton
  @Named('minDesktopWindowSize')
  Size get minDesktopWindowSize => const Size(1075, 800);

  @lazySingleton
  @Named('AIKey')
  String get openAIKey => const String.fromEnvironment(
        'AI_KEY',
        defaultValue: 'none',
      );

  @lazySingleton
  @Named('huggingfaceAIKey')
  String get huggingfaceAIKey => const String.fromEnvironment(
        'HUGGINGFACE_AI_KEY',
        defaultValue: 'none',
      );
}

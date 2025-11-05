import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:vitals_utils/vitals_utils.dart';

final PlatformInfo platformInfo = PlatformInfo(
  _getPlatform(),
  isTest: Platform.environment.containsKey('FLUTTER_TEST'),
  // ignore: avoid_redundant_argument_values
  isProduction: kReleaseMode,
);

Platforms _getPlatform() {
  if (Platform.isAndroid) {
    return Platforms.android;
  } else if (Platform.isIOS) {
    return Platforms.ios;
  } else if (Platform.isMacOS) {
    return Platforms.macos;
  } else if (Platform.isWindows) {
    return Platforms.windows;
  } else if (Platform.isLinux) {
    return Platforms.linux;
  }
  throw Exception('Platform: ${Platform.operatingSystem} is not supported!');
}

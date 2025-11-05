import 'package:flutter/widgets.dart';
import 'package:vitals_utils/src/platform/platform_info.dart';

extension MediaQueryExt on MediaQueryData {
  bool isBigTablet(PlatformInfo platformInfo) => platformInfo.isMobilePlatform && isBigTabletSize;

  bool isTablet(PlatformInfo platformInfo) => platformInfo.isMobilePlatform && isTabletSize;

  bool isMobile(PlatformInfo platformInfo) => platformInfo.isMobilePlatform && !isTabletSize;

  bool get isTabletSize => size.shortestSide >= 600;

  bool get isBigTabletSize => size.shortestSide >= 720;
}

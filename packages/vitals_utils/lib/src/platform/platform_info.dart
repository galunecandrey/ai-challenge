import 'package:flutter/cupertino.dart';
import 'package:vitals_utils/src/platform/display_data.dart';
import 'package:vitals_utils/src/platform/media_query.dart';
import 'package:vitals_utils/src/platform/platforms.dart';

@immutable
class PlatformInfo {
  final Platforms platform;

  final bool isTest;

  final bool isProduction;

  const PlatformInfo(this.platform, {this.isTest = false, this.isProduction = false});

  bool get isWeb => platform == Platforms.web;

  bool get isWindows => platform == Platforms.windows;

  bool get isMacOS => platform == Platforms.macos;

  bool get isAndroid => platform == Platforms.android;

  bool get isIOS => platform == Platforms.ios;

  bool get isLinux => platform == Platforms.linux;

  bool get isMobilePlatform {
    switch (platform) {
      case Platforms.web:
        return false;
      case Platforms.android:
        return true;
      case Platforms.ios:
        return true;
      case Platforms.windows:
        return false;
      case Platforms.macos:
        return false;
      case Platforms.linux:
        return false;
    }
  }

  bool get isDesktop {
    switch (platform) {
      case Platforms.web:
        return false;
      case Platforms.android:
        return false;
      case Platforms.ios:
        return false;
      case Platforms.windows:
        return true;
      case Platforms.macos:
        return true;
      case Platforms.linux:
        return true;
    }
  }

  T mapPlatform<T>({
    required T Function() web,
    required T Function() android,
    required T Function() ios,
    required T Function() windows,
    required T Function() macos,
    required T Function() linux,
  }) {
    switch (platform) {
      case Platforms.web:
        return web();
      case Platforms.android:
        return android();
      case Platforms.ios:
        return ios();
      case Platforms.windows:
        return windows();
      case Platforms.macos:
        return macos();
      case Platforms.linux:
        return linux();
    }
  }

  T? mapPlatformOrNull<T>({
    T Function()? web,
    T Function()? android,
    T Function()? ios,
    T Function()? windows,
    T Function()? macos,
    T Function()? linux,
  }) {
    switch (platform) {
      case Platforms.web:
        return web?.call();
      case Platforms.android:
        return android?.call();
      case Platforms.ios:
        return ios?.call();
      case Platforms.windows:
        return windows?.call();
      case Platforms.macos:
        return macos?.call();
      case Platforms.linux:
        return linux?.call();
    }
  }

  T maybeMapPlatform<T>({
    required T Function() orElse,
    T Function()? web,
    T Function()? android,
    T Function()? ios,
    T Function()? windows,
    T Function()? macos,
    T Function()? linux,
  }) {
    switch (platform) {
      case Platforms.web:
        return (web ?? orElse)();
      case Platforms.android:
        return (android ?? orElse)();
      case Platforms.ios:
        return (ios ?? orElse)();
      case Platforms.windows:
        return (windows ?? orElse)();
      case Platforms.macos:
        return (macos ?? orElse)();
      case Platforms.linux:
        return (linux ?? orElse)();
    }
  }

  @override
  String toString() => 'PlatformInfo($platform, isTest: $isTest)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformInfo && runtimeType == other.runtimeType && platform == other.platform && isTest == other.isTest;

  @override
  int get hashCode => platform.hashCode ^ isTest.hashCode;
}

extension PlatformInfoExt on PlatformInfo {
  bool isBigTablet(MediaQueryData mediaQueryData, DisplayData displayData) =>
      isMobilePlatform && mediaQueryData.isBigTabletSize;

  bool isTablet(MediaQueryData mediaQueryData, DisplayData displayData) =>
      isMobilePlatform && _isTabletSize(mediaQueryData, displayData);

  bool isMobile(MediaQueryData mediaQueryData, DisplayData displayData) =>
      isMobilePlatform && !_isTabletSize(mediaQueryData, displayData);

  bool _isTabletSize(MediaQueryData mediaQueryData, DisplayData displayData) =>
      (isAndroid && displayData.isTabletSize && mediaQueryData.orientation == Orientation.landscape)
          ? mediaQueryData.size.shortestSide >= 540
          : mediaQueryData.isTabletSize;
}

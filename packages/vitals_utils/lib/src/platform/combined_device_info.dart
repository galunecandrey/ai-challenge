import 'package:flutter/cupertino.dart';
import 'package:vitals_utils/src/platform/display_data.dart';
import 'package:vitals_utils/src/platform/platform_info.dart';
import 'package:vitals_utils/src/platform/platforms.dart';
import 'package:vitals_utils/src/platform/vis_package_info.dart';

@immutable
class CombinedDeviceInfo {
  final PlatformInfo platformInfo;

  final MediaQueryData mediaQueryData;

  final DisplayData displayData;

  final VisPackageInfo packageInfo;

  final bool is24HoursTimeFormat;

  final bool hasEarpiece;

  const CombinedDeviceInfo({
    required this.platformInfo,
    required this.mediaQueryData,
    required this.displayData,
    required this.packageInfo,
    required this.is24HoursTimeFormat,
    required this.hasEarpiece,
  });

  bool get isWeb => platformInfo.isWeb;

  bool get isProduction => platformInfo.isProduction;

  bool get isWindows => platformInfo.isWindows;

  bool get isMacOS => platformInfo.isMacOS;

  bool get isAndroid => platformInfo.isAndroid;

  bool get isIOS => platformInfo.isIOS;

  bool get isLinux => platformInfo.isLinux;

  bool get isMobilePlatform => platformInfo.isMobilePlatform;

  bool get isDesktop => platformInfo.isDesktop;

  bool get isTest => platformInfo.isTest;

  bool get isBigTablet => platformInfo.isBigTablet(mediaQueryData, displayData);

  bool get isMobile => platformInfo.isMobile(mediaQueryData, displayData);

  bool get isTablet => platformInfo.isTablet(mediaQueryData, displayData);

  T mapOS<T>({
    required T Function() web,
    required T Function() android,
    required T Function() ios,
    required T Function() windows,
    required T Function() macos,
    required T Function() linux,
  }) =>
      platformInfo.mapPlatform(
        web: web,
        android: android,
        ios: ios,
        windows: windows,
        macos: macos,
        linux: linux,
      );

  T mapDevice<T>({
    required T Function() mobile,
    required T Function() tablet,
    required T Function() desktop,
    required T Function() web,
  }) {
    switch (platformInfo.platform) {
      case Platforms.web:
        return web();
      case Platforms.android:
      case Platforms.ios:
        return (isTablet ? tablet : mobile)();
      case Platforms.windows:
      case Platforms.macos:
      case Platforms.linux:
        return desktop();
    }
  }

  T? mapOSOrNull<T>({
    T Function()? web,
    T Function()? android,
    T Function()? ios,
    T Function()? windows,
    T Function()? macos,
    T Function()? linux,
  }) =>
      platformInfo.mapPlatformOrNull(
        web: web,
        android: android,
        ios: ios,
        windows: windows,
        macos: macos,
        linux: linux,
      );

  T? mapDeviceOrNull<T>({
    T Function()? web,
    T Function()? mobile,
    T Function()? tablet,
    T Function()? desktop,
  }) {
    switch (platformInfo.platform) {
      case Platforms.web:
        return web?.call();
      case Platforms.android:
      case Platforms.ios:
        return (isTablet ? tablet : mobile)?.call();
      case Platforms.windows:
      case Platforms.macos:
      case Platforms.linux:
        return desktop?.call();
    }
  }

  T maybeMapOS<T>({
    required T Function() orElse,
    T Function()? web,
    T Function()? android,
    T Function()? ios,
    T Function()? windows,
    T Function()? macos,
    T Function()? linux,
  }) =>
      platformInfo.maybeMapPlatform(
        orElse: orElse,
        web: web,
        android: android,
        ios: ios,
        windows: windows,
        macos: macos,
        linux: linux,
      );

  T maybeMapDevice<T>({
    required T Function() orElse,
    T Function()? web,
    T Function()? mobile,
    T Function()? tablet,
    T Function()? desktop,
  }) {
    switch (platformInfo.platform) {
      case Platforms.web:
        return (web ?? orElse)();
      case Platforms.android:
      case Platforms.ios:
        return ((isTablet ? tablet : mobile) ?? orElse)();
      case Platforms.windows:
      case Platforms.macos:
      case Platforms.linux:
        return (desktop ?? orElse)();
    }
  }

  CombinedDeviceInfo copyWith({
    PlatformInfo? platformInfo,
    MediaQueryData? mediaQueryData,
    VisPackageInfo? packageInfo,
    DisplayData? displayData,
    bool? is24HoursTimeFormat,
    bool? hasEarpiece,
  }) =>
      CombinedDeviceInfo(
        platformInfo: platformInfo ?? this.platformInfo,
        mediaQueryData: mediaQueryData ?? this.mediaQueryData,
        displayData: displayData ?? this.displayData,
        packageInfo: packageInfo ?? this.packageInfo,
        is24HoursTimeFormat: is24HoursTimeFormat ?? this.is24HoursTimeFormat,
        hasEarpiece: hasEarpiece ?? this.hasEarpiece,
      );

  @override
  String toString() => 'CombinedDeviceInfo{'
      'platformInfo: $platformInfo, '
      'mediaQueryData: $mediaQueryData, '
      'displayData: $displayData, '
      'packageInfo: $packageInfo, '
      'is24HoursTimeFormat: $is24HoursTimeFormat, '
      'hasEarpiece: $hasEarpiece}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombinedDeviceInfo &&
          runtimeType == other.runtimeType &&
          platformInfo == other.platformInfo &&
          mediaQueryData == other.mediaQueryData &&
          displayData == other.displayData &&
          packageInfo == other.packageInfo &&
          is24HoursTimeFormat == other.is24HoursTimeFormat &&
          hasEarpiece == other.hasEarpiece;

  @override
  int get hashCode =>
      platformInfo.hashCode ^
      mediaQueryData.hashCode ^
      displayData.hashCode ^
      packageInfo.hashCode ^
      is24HoursTimeFormat.hashCode ^
      hasEarpiece.hashCode;
}

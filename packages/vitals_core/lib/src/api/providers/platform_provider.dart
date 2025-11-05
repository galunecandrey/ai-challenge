import 'package:flutter/material.dart';
import 'package:vitals_utils/vitals_utils.dart';

abstract class PlatformProvider {
  PlatformInfo get platformInfo;

  MediaQueryData get mediaQueryData;

  DisplayData get displayData;

  CombinedDeviceInfo get data;

  Size get size;

  bool get isDesktop;

  bool get isBigTablet;

  bool get isTablet;

  bool get isMobile;

  bool get isWeb;

  bool get isWindows;

  bool get isMacOS;

  bool get isAndroid;

  bool get isIOS;

  bool get isLinux;

  bool get isMobilePlatform;

  bool get isTest;

  bool get isProduction;

  bool get is24TimeFormat;

  bool get hasEarpiece;

  String get appVersion;

  String get appName;

  bool get isSamsung;

  Stream<T> stream<T>(
    T Function(PlatformProvider) map, {
    bool sendFirst = false,
  });

  Future<Either<BaseError, VisPackageInfo>> fetchPackageInfo();

  Future<Either<BaseError, VisPackageInfo>> fetchDeviceInfo();

  Future<Either<BaseError, Unit>> fetchSystemTimeFormat();

  Future<Either<BaseError, Unit>> fetchHasEarpiece();

  void dispose();
}

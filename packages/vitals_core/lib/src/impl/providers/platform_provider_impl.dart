import 'package:desktop_window/desktop_window.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
//ignore:depend_on_referenced_packages
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:system_tools/system_tools.dart';
import 'package:vitals_core/src/api/providers/platform_provider.dart';
import 'package:vitals_core/src/model/error/exception.dart';
import 'package:vitals_utils/vitals_utils.dart';

@LazySingleton(as: PlatformProvider)
class PlatformProviderImpl extends Disposable with WidgetsBindingObserver implements PlatformProvider {
  final OperationService _operationService;
  final PackageInfoPlatform _packageInfoPlatform;
  final DeviceInfoPlugin _deviceInfoPlugin;
  late final StateStream<CombinedDeviceInfo> _data;

  PlatformProviderImpl(
    this._operationService,
    this._packageInfoPlatform,
    this._deviceInfoPlugin,
    PlatformInfo platformInfo,
    @Named('minDesktopWindowSize') Size minDesktopWindowSize,
  ) {
    final flutterView = WidgetsBinding.instance.platformDispatcher.views.first;
    _data = stateOf(
      CombinedDeviceInfo(
        platformInfo: platformInfo,
        mediaQueryData: MediaQueryData.fromView(
          flutterView,
        ),
        displayData: DisplayData.fromDisplay(
          flutterView.display,
        ),
        packageInfo: const VisPackageInfo(
          packageName: '',
          appName: '',
          buildNumber: '',
          version: '',
          buildSignature: '',
          deviceName: '',
        ),
        is24HoursTimeFormat: false,
        hasEarpiece: false,
      ),
    );
    WidgetsBinding.instance.addObserver(this);
    if (data.isMobilePlatform) {
      _streamTablet.distinct().listen((event) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          if (event) ...[
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        ]);
      }).cancelable(cancelable);
    }
    if (data.isDesktop) {
      _data(sendFirst: true)
          .map((event) {
            final size = event.mediaQueryData.size;
            return (
              size.height >= minDesktopWindowSize.height && size.width >= minDesktopWindowSize.width,
              size,
            );
          })
          .distinct((p, n) => p.$1 == n.$1)
          .listen((event) {
            if (!event.$1) {
              _setWindowSize(
                current: event.$2,
                minDesktopWindowSize: minDesktopWindowSize,
              );
            }
          })
          .cancelable(cancelable);
      _setMinDesktopWindowSize(minDesktopWindowSize);
    }
  }

  Future<void> _setWindowSize({
    required Size current,
    required Size minDesktopWindowSize,
  }) =>
      Future.wait<dynamic>([
        DesktopWindow.setWindowSize(
          _mergeSize(
            current: current,
            minDesktopWindowSize: minDesktopWindowSize,
          ),
        ),
        _setMinDesktopWindowSize(minDesktopWindowSize),
      ]);

  Future<void> _setMinDesktopWindowSize(Size minDesktopWindowSize) =>
      DesktopWindow.setMinWindowSize(minDesktopWindowSize);

  Size _mergeSize({
    required Size current,
    required Size minDesktopWindowSize,
  }) =>
      Size(
        current.width >= minDesktopWindowSize.width ? current.width : minDesktopWindowSize.width,
        current.height >= minDesktopWindowSize.height ? current.height : minDesktopWindowSize.height,
      );

  String _getTag(String method) => 'PlatformProvider.$method';

  Stream<bool> get _streamTablet async* {
    yield _data.value.isTablet;
    yield* _data.stream.map((e) => e.isTablet).distinct();
  }

  @override
  PlatformInfo get platformInfo => _data.value.platformInfo;

  @override
  MediaQueryData get mediaQueryData => _data.value.mediaQueryData;

  @override
  DisplayData get displayData => _data.value.displayData;

  @override
  CombinedDeviceInfo get data => _data.value;

  @override
  Size get size => mediaQueryData.size;

  @override
  bool get isBigTablet => _data.value.isBigTablet;

  @override
  bool get isMobile => _data.value.isMobile;

  @override
  bool get isTablet => _data.value.isTablet;

  @override
  bool get isWeb => _data.value.isWeb;

  @override
  bool get isWindows => _data.value.isWindows;

  @override
  bool get isMacOS => _data.value.isMacOS;

  @override
  bool get isAndroid => _data.value.isAndroid;

  @override
  bool get isIOS => _data.value.isIOS;

  @override
  bool get isProduction => _data.value.isProduction;

  @override
  bool get isLinux => _data.value.isLinux;

  @override
  bool get isTest => _data.value.isTest;

  @override
  String get appVersion => _data.value.packageInfo.version;

  @override
  String get appName => _data.value.packageInfo.appName;

  @override
  bool get isDesktop => _data.value.isDesktop;

  @override
  bool get isMobilePlatform => _data.value.isMobilePlatform;

  @override
  bool get is24TimeFormat => _data.value.is24HoursTimeFormat;

  @override
  bool get hasEarpiece => _data.value.hasEarpiece;

  @override
  bool get isSamsung => isAndroid && data.packageInfo.deviceName.toUpperCase().startsWith('SM');

  @override
  void didChangeMetrics() {
    final flutterView = WidgetsBinding.instance.platformDispatcher.views.first;
    _operationService
        .safeSyncOp(
          () => _data.value.copyWith(
            mediaQueryData: MediaQueryData.fromView(
              flutterView,
            ),
            displayData: DisplayData.fromDisplay(flutterView.display),
          ),
          tag: _getTag('didChangeMetrics'),
          shouldTrackLog: false,
        )
        .forEach(_data.add);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchSystemTimeFormat();
    }
  }

  @disposeMethod
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Stream<T> stream<T>(
    T Function(PlatformProvider provider) map, {
    bool sendFirst = false,
  }) async* {
    if (sendFirst) {
      yield map(this);
    }
    yield* _data.map((event) => map(this));
  }

  @override
  Future<Either<BaseError, VisPackageInfo>> fetchPackageInfo() => _operationService.safeAsyncOp(
        () => _packageInfoPlatform
            .getAll()
            .then(
              (packageInfo) => _data.add(
                _data.value.copyWith(
                  packageInfo: _data.value.packageInfo.copyWith(
                    appName: packageInfo.appName,
                    packageName: packageInfo.packageName,
                    version: packageInfo.version,
                    buildNumber: packageInfo.buildNumber,
                    buildSignature: packageInfo.buildSignature,
                  ),
                ),
              ),
            )
            .then((value) => data.packageInfo),
        tag: _getTag('fetchPackageInfo'),
      );

  @override
  Future<Either<BaseError, VisPackageInfo>> fetchDeviceInfo() => _operationService.safeAsyncOp(
        () => _deviceInfoPlugin.deviceInfo
            .then(
              (deviceInfo) => _data.add(
                _data.value.copyWith(
                  packageInfo: _data.value.packageInfo.copyWith(
                    deviceName: switch (deviceInfo) {
                      AndroidDeviceInfo(model: final String model) => model,
                      IosDeviceInfo(utsname: final IosUtsname utsname) => utsname.machine,
                      MacOsDeviceInfo(model: final String model) => model,
                      WindowsDeviceInfo(computerName: final String computerName) => computerName,
                      _ => throw const NoSupportException(),
                    },
                  ),
                ),
              ),
            )
            .then((value) => data.packageInfo),
        tag: _getTag('fetchPackageInfo'),
      );

  @override
  Future<Either<BaseError, Unit>> fetchSystemTimeFormat() => _operationService.safeUnitAsyncOp(
        () => SystemTools.is24hoursTimeFormat().then<void>(
          (is24HoursFormat) => _data.add(_data.value.copyWith(is24HoursTimeFormat: is24HoursFormat)),
        ),
        tag: _getTag('fetchSystemTimeFormat'),
      );

  @override
  Future<Either<BaseError, Unit>> fetchHasEarpiece() => _operationService.safeUnitAsyncOp(
        () => SystemTools.hasEarpiece().then<void>(
          (hasEarpiece) => _data.add(_data.value.copyWith(hasEarpiece: hasEarpiece)),
        ),
        tag: _getTag('fetchHasEarpiece'),
      );
}

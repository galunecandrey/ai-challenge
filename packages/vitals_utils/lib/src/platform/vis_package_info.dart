import 'package:flutter/foundation.dart';

@immutable
class VisPackageInfo {
  final String appName;

  final String packageName;

  final String version;

  final String buildNumber;

  final String buildSignature;

  final String deviceName;

  const VisPackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.buildSignature,
    required this.deviceName,
  });

  VisPackageInfo copyWith({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
    String? buildSignature,
    String? deviceName,
  }) =>
      VisPackageInfo(
        appName: appName ?? this.appName,
        packageName: packageName ?? this.packageName,
        version: version ?? this.version,
        buildNumber: buildNumber ?? this.buildNumber,
        buildSignature: buildSignature ?? this.buildSignature,
        deviceName: deviceName ?? this.deviceName,
      );

  @override
  String toString() => 'VisPackageInfo{'
      'appName: $appName, '
      'packageName: $packageName, '
      'version: $version, '
      'buildNumber: $buildNumber, '
      'buildSignature: $buildSignature, '
      'deviceName: $deviceName}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisPackageInfo &&
          runtimeType == other.runtimeType &&
          appName == other.appName &&
          packageName == other.packageName &&
          version == other.version &&
          buildNumber == other.buildNumber &&
          buildSignature == other.buildSignature &&
          deviceName == other.deviceName;

  @override
  int get hashCode =>
      appName.hashCode ^
      packageName.hashCode ^
      version.hashCode ^
      buildNumber.hashCode ^
      buildSignature.hashCode ^
      deviceName.hashCode;
}

import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class DisplayData {
  final double devicePixelRatio;

  /// The physical size of this display.
  final Size physicalSize;

  /// The logical size of this display.
  final Size size;

  /// The refresh rate in FPS of this display.
  final double refreshRate;

  const DisplayData({
    required this.physicalSize,
    required this.devicePixelRatio,
    required this.refreshRate,
  }) : size = physicalSize / devicePixelRatio;

  DisplayData.fromDisplay(Display display)
      : physicalSize = display.size,
        devicePixelRatio = display.devicePixelRatio,
        refreshRate = display.refreshRate,
        size = display.size / display.devicePixelRatio;

  @override
  String toString() => 'DisplayData{'
      'devicePixelRatio: $devicePixelRatio, '
      'physicalSize: $physicalSize, '
      'size: $size, '
      'refreshRate: $refreshRate}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayData &&
          runtimeType == other.runtimeType &&
          devicePixelRatio == other.devicePixelRatio &&
          physicalSize == other.physicalSize &&
          size == other.size &&
          refreshRate == other.refreshRate;

  @override
  int get hashCode => devicePixelRatio.hashCode ^ physicalSize.hashCode ^ size.hashCode ^ refreshRate.hashCode;
}

extension DisplayDataExt on DisplayData {
  bool get isTabletSize => size.shortestSide >= 600;

  bool get isBigTabletSize => size.shortestSide >= 720;
}

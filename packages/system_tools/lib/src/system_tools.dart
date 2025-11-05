import 'package:flutter/services.dart';

class SystemTools {
  static const methodChannel = MethodChannel('system_tools');

  static Future<bool> is24hoursTimeFormat() =>
      methodChannel.invokeMethod<bool>('is24hoursTimeFormat').then((value) => value!);

  static Future<bool> hasEarpiece() => methodChannel.invokeMethod<bool>('hasEarpiece').then((value) => value ?? false);
}

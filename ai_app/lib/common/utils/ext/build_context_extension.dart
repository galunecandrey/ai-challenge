import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';

extension BuildContextExt on BuildContext {
  void closeKeyboard() {
    if (read<PlatformProvider>().isMobilePlatform) {
      final currentFocus = FocusScope.of(this);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }
}

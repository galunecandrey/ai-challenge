import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:system_tray/system_tray.dart';
import 'package:vitals_core/vitals_core.dart';

@lazySingleton
class VitalsSystemTrayManager {
  final PlatformProvider _platformProvider;
  late final SystemTray _systemTray = SystemTray();
  late final Menu _trayMenu = Menu();
  late final AppWindow _appWindow = AppWindow();

  VitalsSystemTrayManager(this._platformProvider) {
    if (_platformProvider.isDesktop) {
      initSystemTray();
    }
  }

  Future<void> initSystemTray() async {
    await _systemTray.destroy();
    await _systemTray.initSystemTray(
      iconPath: 'assets/images/systray_icon.${_platformProvider.isWindows ? 'ico' : 'png'}',
    );
    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      }
      if (eventName == kSystemTrayEventClick) {
        _appWindow.show();
      }
    });

    await _trayMenu.buildFrom(
      [
        MenuItemLabel(
          label: 'Quit',
          onClicked: (_) => exit(0),
        ),
      ],
    );

    await _systemTray.setContextMenu(_trayMenu);
  }
}

#include "include/system_tools/system_tools_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "system_tools_plugin.h"

void SystemToolsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  system_tools::SystemToolsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

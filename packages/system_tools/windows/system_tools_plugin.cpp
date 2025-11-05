#include "system_tools_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace system_tools {

// static
void SystemToolsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "system_tools",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<SystemToolsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

SystemToolsPlugin::SystemToolsPlugin() {}

SystemToolsPlugin::~SystemToolsPlugin() {}

void SystemToolsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("is24hoursTimeFormat") == 0)
  {
    wchar_t localeInfo[2];
    const int ciResultCode = GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT, LOCALE_ITIME, localeInfo, 2);
    if (ciResultCode <= 0)
    {
      result->Error(0, "Failed to retrieve locale info. Last error code: " + GetLastError());
    }

    // 0 - AM/PM format, 1 - 24h
    result->Success(flutter::EncodableValue(wcscmp(localeInfo, L"1") == 0));
  } 
  else 
  {
    result->NotImplemented();
  }
}

}  // namespace system_tools

#ifndef FLUTTER_PLUGIN_SYSTEM_tools_PLUGIN_H_
#define FLUTTER_PLUGIN_SYSTEM_tools_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace system_tools {

class SystemToolsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SystemToolsPlugin();

  virtual ~SystemToolsPlugin();

  // Disallow copy and assign.
  SystemToolsPlugin(const SystemToolsPlugin&) = delete;
  SystemToolsPlugin& operator=(const SystemToolsPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace system_tools

#endif  // FLUTTER_PLUGIN_SYSTEM_tools_PLUGIN_H_

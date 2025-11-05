import Cocoa
import FlutterMacOS

public class SystemToolsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.addMethodCallDelegate(
            SystemToolsPlugin(),
            channel: FlutterMethodChannel(
                name: "system_tools",
                binaryMessenger: registrar.messenger
            )
        )
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "is24hoursTimeFormat") {
            let locale = NSLocale.current
            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
            if formatter.contains("a") {
                result(false)
            } else {
                result(true)
            }
        }
        
        else {
            result(FlutterMethodNotImplemented)
        }
    }
}

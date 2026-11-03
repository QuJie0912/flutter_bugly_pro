import Flutter
#if canImport(Bugly) && !targetEnvironment(simulator)
import Bugly
#endif
import UIKit

public class FlutterBuglyProPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_bugly_pro", binaryMessenger: registrar.messenger())
        let instance = FlutterBuglyProPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case "init":
#if canImport(Bugly) && !targetEnvironment(simulator)
            if let arguments = arguments {
                if let appId = arguments["appId"] as? String {
                    let config = BuglyConfig()
                    let channel = arguments["channel"] as? String
                    if let channel = channel {
                        config.channel = channel
                    }
                    Bugly.start(withAppId: appId, config: config)
                }
            }
#endif
            result(nil)
        case "setUserIdentifier":
#if canImport(Bugly) && !targetEnvironment(simulator)
            if let arguments = arguments, let userId = arguments["userId"] as? String {
                Bugly.setUserIdentifier(userId)
            }
#endif
            result(nil)
        case "reportException":
#if canImport(Bugly) && !targetEnvironment(simulator)
            if let arguments = arguments {
                let exception = arguments["exception"] as? String
                let stackTrace = arguments["stackTrace"] as? String
                let callStack = stackTrace?.split(separator: "\n") ?? []
                Bugly.reportException(withCategory: 5, name: exception ?? "unknown", reason: "Flutter Exception", callStack: callStack, extraInfo: ["exception": exception ?? "", "stackTrace": stackTrace ?? ""], terminateApp: false)
            }
#endif
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

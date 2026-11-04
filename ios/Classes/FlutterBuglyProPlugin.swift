import Flutter
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
        case "initBugly":
            let appId = arguments?["appId"] as? String
            if isBlank(appId) {
                result(resultJson(success: false, appId: nil, message: "Bugly appId不能为空"))
                return
            }
            var config = BuglyBridgeConfig()
            config.channel = nonBlank(arguments?["channel"] as? String)
            config.appVersion = nonBlank(arguments?["appVersion"] as? String)
            config.unexpectedTerminatingDetectionEnable = boolValue(arguments?["unexpectedTerminatingDetectionEnable"])
            config.blockMonitorEnable = boolValue(arguments?["enableBlockMonitor"])
            config.blockMonitorTimeout = doubleValue(arguments?["blockMonitorTimeout"], fallback: 3)
            config.debugMode = boolValue(arguments?["debugMode"])
            config.symbolicateInProcessEnable = boolValue(arguments?["symbolicateInProcessEnable"])
            config.reportLogLevel = (arguments?["reportLogLevel"] as? NSNumber)?.intValue
            BuglyBridge.start(appId: appId!, config: config)
            if config.debugMode {
                NSLog("Bugly appId: %@", appId!)
            }
            result(resultJson(success: true, appId: appId, message: "Bugly 初始化成功"))
        case "postCatchedException":
            var type = arguments?["crash_type"] as? String
            var message = arguments?["crash_message"] as? String
            let detail = arguments?["crash_detail"] as? String
            if isBlank(detail) {
                message = ""
            }
            if isBlank(type) {
                type = message
            }
            let callStack: [String] = detail.map { ($0 as NSString).components(separatedBy: "") } ?? []
            var extraInfo: [AnyHashable: Any] = [:]
            if let data = arguments?["crash_data"] as? [AnyHashable: Any] {
                for (key, value) in data {
                    extraInfo[key] = value
                }
            }
            BuglyBridge.reportException(name: type ?? "", reason: message ?? "", callStack: callStack, extraInfo: extraInfo)
            result(nil)
        case "setUserId":
            if let userId = arguments?["userId"] as? String, !isBlank(userId) {
                BuglyBridge.setUserIdentifier(userId)
            }
            result(nil)
        case "setUserTag":
            if let tag = arguments?["userTag"] as? NSNumber {
                BuglyBridge.setTag(tag.intValue)
            }
            result(nil)
        case "setAppVersion":
            if let appVersion = arguments?["appVersion"] as? String, !isBlank(appVersion) {
                BuglyBridge.updateAppVersion(appVersion)
            }
            result(nil)
        case "putUserData":
            let key = arguments?["key"] as? String
            let value = arguments?["value"] as? String
            if let key = key, let value = value, !isBlank(key), !isBlank(value) {
                BuglyBridge.setUserValue(value, forKey: key)
            }
            result(nil)
        case "log":
            let level = (arguments?["log_level"] as? NSNumber)?.intValue ?? 0
            let tag = arguments?["log_tag"] as? String
            let message = arguments?["log_message"] as? String
            BuglyBridge.log(level: level, tag: tag, message: message)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func resultJson(success: Bool, appId: String?, message: String) -> String {
        var dict: [String: Any] = ["message": message, "isSuccess": success]
        if let appId = appId {
            dict["appId"] = appId
        }
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
              let json = String(data: data, encoding: .utf8) else {
            return "{\"isSuccess\":\(success),\"message\":\"\(message)\"}"
        }
        return json
    }

    private func nonBlank(_ value: String?) -> String? {
        guard let value = value, !isBlank(value) else {
            return nil
        }
        return value
    }

    private func boolValue(_ value: Any?) -> Bool {
        return (value as? Bool) ?? false
    }

    private func doubleValue(_ value: Any?, fallback: Double) -> Double {
        guard let number = value as? NSNumber, number.doubleValue > 0 else {
            return fallback
        }
        return number.doubleValue
    }

    private func isBlank(_ value: Any?) -> Bool {
        guard let value = value, !(value is NSNull) else {
            return true
        }
        if let string = value as? String {
            return string.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return false
    }
}

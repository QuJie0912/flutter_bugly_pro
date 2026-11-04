import Foundation

#if canImport(Bugly) && !targetEnvironment(simulator)
import Bugly
#endif

struct BuglyBridgeConfig {
    var channel: String?
    var appVersion: String?
    var unexpectedTerminatingDetectionEnable: Bool = false
    var blockMonitorEnable: Bool = false
    var blockMonitorTimeout: TimeInterval = 3
    var debugMode: Bool = false
    var symbolicateInProcessEnable: Bool = false
    var reportLogLevel: Int?
}

#if canImport(Bugly) && !targetEnvironment(simulator)
enum BuglyBridge {
    static func start(appId: String, config: BuglyBridgeConfig) {
        let buglyConfig = BuglyConfig()
        if let channel = config.channel, !channel.isEmpty {
            buglyConfig.channel = channel
        }
        if let appVersion = config.appVersion, !appVersion.isEmpty {
            buglyConfig.version = appVersion
        }
        buglyConfig.unexpectedTerminatingDetectionEnable = config.unexpectedTerminatingDetectionEnable
        buglyConfig.blockMonitorEnable = config.blockMonitorEnable
        buglyConfig.blockMonitorTimeout = config.blockMonitorTimeout
        buglyConfig.debugMode = config.debugMode
        buglyConfig.symbolicateInProcessEnable = config.symbolicateInProcessEnable
        if let reportLogLevel = config.reportLogLevel,
           let level = BuglyLogLevel(rawValue: UInt(reportLogLevel)) {
            buglyConfig.reportLogLevel = level
        }
        Bugly.start(withAppId: appId, config: buglyConfig)
    }

    static func setUserIdentifier(_ userId: String) {
        Bugly.setUserIdentifier(userId)
    }

    static func setTag(_ tag: Int) {
        Bugly.setTag(UInt(bitPattern: tag))
    }

    static func setUserValue(_ value: String, forKey key: String) {
        Bugly.setUserValue(value, forKey: key)
    }

    static func updateAppVersion(_ version: String) {
        Bugly.updateAppVersion(version)
    }

    static func reportException(name: String, reason: String, callStack: [Any], extraInfo: [AnyHashable: Any]) {
        Bugly.reportException(withCategory: 5, name: name, reason: reason,
                              callStack: callStack, extraInfo: extraInfo, terminateApp: false)
    }

    static func log(level: Int, tag: String?, message: String?) {
        BuglyLogBridgeLog(level, tag, message)
    }
}
#else
enum BuglyBridge {
    static func start(appId: String, config: BuglyBridgeConfig) {}

    static func setUserIdentifier(_ userId: String) {}

    static func setTag(_ tag: Int) {}

    static func setUserValue(_ value: String, forKey key: String) {}

    static func updateAppVersion(_ version: String) {}

    static func reportException(name: String, reason: String, callStack: [Any], extraInfo: [AnyHashable: Any]) {}

    static func log(level: Int, tag: String?, message: String?) {}
}
#endif

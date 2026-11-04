import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bugly_pro_method_channel.dart';
import 'src/bean/init_result_info.dart';
import 'src/types/log_level.dart';

abstract class FlutterBuglyProPlatform extends PlatformInterface {
  /// Constructs a FlutterBuglyProPlatform.
  FlutterBuglyProPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBuglyProPlatform _instance = MethodChannelFlutterBuglyPro();

  /// The default instance of [FlutterBuglyProPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBuglyPro].
  static FlutterBuglyProPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBuglyProPlatform] when
  /// they register themselves.
  static set instance(FlutterBuglyProPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<InitResultInfo> init({
    String? androidAppId,
    String? iOSAppId,
    String? ohosAppId,
    String? channel,
    String? deviceId,
    String? appVersion,
    String? userId,
    bool debugMode = kDebugMode,
    int initDelay = 0,
    String? deviceModel,
    String? appPackage,
    bool enableCatchAnrTrace = false,
    bool enableRecordAnrMainStack = true,
    bool isBuglyLogUpload = true,
    double blockMonitorTimeout = 3,
    bool unexpectedTerminatingDetectionEnable = true,
    bool enableBlockMonitor = true,
    bool symbolicateInProcessEnable = true,
    int? reportLogLevel,
    String? appKey,
    String? buildNum,
  });

  Future<Null> setUserId(String userId);

  Future<Null> setUserTag(int userSceneTag);

  Future<Null> putUserData({
    required String key,
    required String value,
  });

  Future<Null> uploadException({
    required String message,
    required String detail,
    String? type,
    Map? data,
  });

  Future<Null> setAppChannel(String channel);

  Future<Null> setDeviceModel(String deviceModel);

  Future<Null> setAppPackageName(String appPackage);

  Future<Null> setAppVersion(String appVersion);

  Future<Null> setDeviceID(String deviceId);

  Future<Null> log({
    required String tag,
    required String message,
    LogLevel level = LogLevel.INFO,
  });
}

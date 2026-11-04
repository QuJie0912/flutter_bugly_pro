import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bugly_pro_platform_interface.dart';
import 'src/bean/init_result_info.dart';
import 'src/types/log_level.dart';

/// An implementation of [FlutterBuglyProPlatform] that uses method channels.
class MethodChannelFlutterBuglyPro extends FlutterBuglyProPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bugly_pro');

  @override
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
  }) async {
    Map<String, Object?> map = {
      "appId": Platform.isAndroid
          ? androidAppId
          : (Platform.isIOS ? iOSAppId : ohosAppId),
      "channel": channel,
      "deviceId": deviceId,
      "appVersion": appVersion,
      "userId": userId,
      "debugMode": debugMode,
      //android
      "deviceModel": deviceModel,
      "initDelay": initDelay,
      "appPackage": appPackage,
      "enableCatchAnrTrace": enableCatchAnrTrace,
      "enableRecordAnrMainStack": enableRecordAnrMainStack,
      "isBuglyLogUpload": isBuglyLogUpload,
      //iOS
      "blockMonitorTimeout": blockMonitorTimeout,
      "unexpectedTerminatingDetectionEnable":
          unexpectedTerminatingDetectionEnable,
      "enableBlockMonitor": enableBlockMonitor,
      "symbolicateInProcessEnable": symbolicateInProcessEnable,
      "reportLogLevel": reportLogLevel,
      //ohos
      "appKey": appKey,
      "buildNum": buildNum,
    };
    final dynamic result = await methodChannel.invokeMethod('initBugly', map);
    Map resultMap = json.decode(result);
    return InitResultInfo.fromJson(resultMap as Map<String, dynamic>);
  }

  @override
  Future<Null> setUserId(String userId) async {
    Map<String, Object> map = {"userId": userId};
    await methodChannel.invokeMethod('setUserId', map);
  }

  @override
  Future<Null> setUserTag(int userSceneTag) async {
    Map<String, Object> map = {"userTag": userSceneTag};
    await methodChannel.invokeMethod('setUserTag', map);
  }

  @override
  Future<Null> putUserData({
    required String key,
    required String value,
  }) async {
    Map<String, Object> map = {"key": key, "value": value};
    await methodChannel.invokeMethod('putUserData', map);
  }

  @override
  Future<Null> uploadException({
    required String message,
    required String detail,
    String? type,
    Map? data,
  }) async {
    var map = {};
    map.putIfAbsent("crash_message", () => message);
    map.putIfAbsent("crash_detail", () => detail);
    map.putIfAbsent("crash_type", () => type);
    if (data != null) map.putIfAbsent("crash_data", () => data);
    await methodChannel.invokeMethod('postCatchedException', map);
  }

  @override
  Future<Null> setAppChannel(String channel) async {
    Map<String, Object> map = {"channel": channel};
    await methodChannel.invokeMethod('setAppChannel', map);
  }

  @override
  Future<Null> setDeviceModel(String deviceModel) async {
    Map<String, Object> map = {"deviceModel": deviceModel};
    await methodChannel.invokeMethod('setDeviceModel', map);
  }

  @override
  Future<Null> setAppPackageName(String appPackage) async {
    Map<String, Object> map = {"appPackage": appPackage};
    await methodChannel.invokeMethod('setAppPackageName', map);
  }

  @override
  Future<Null> setAppVersion(String appVersion) async {
    Map<String, Object> map = {"appVersion": appVersion};
    await methodChannel.invokeMethod('setAppVersion', map);
  }

  @override
  Future<Null> setDeviceID(String deviceId) async {
    Map<String, Object> map = {"deviceId": deviceId};
    await methodChannel.invokeMethod('setDeviceID', map);
  }

  @override
  Future<Null> log({
    required String tag,
    required String message,
    LogLevel level = LogLevel.INFO,
  }) async {
    Map<String, Object> map = {
      "log_level": level.index + 1,
      "log_tag": tag,
      "log_message": message
    };
    await methodChannel.invokeMethod('log', map);
  }
}

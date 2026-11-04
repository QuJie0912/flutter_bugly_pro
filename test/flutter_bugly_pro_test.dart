import 'package:flutter_bugly_pro/flutter_bugly_pro.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro_method_channel.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro_platform_interface.dart';
import 'package:flutter_bugly_pro/src/defaults.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBuglyProPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBuglyProPlatform {
  @override
  Future<InitResultInfo> init({
    String? androidAppId,
    String? iOSAppId,
    String? ohosAppId,
    String? channel,
    String? deviceId,
    String? appVersion,
    String? userId,
    bool debugMode = false,
    int initDelay = 0,
    String? deviceModel,
    String? appPackage,
    bool enableCatchAnrTrace = false,
    bool enableRecordAnrMainStack = true,
    bool isBuglyLogUpload = true,
    double blockMonitorTimeout = 3,
    bool unexpectedTerminatingDetectionEnable = true,
    bool enableBlockMonitor = defaultEnableBlockMonitor,
    bool symbolicateInProcessEnable = true,
    int? reportLogLevel,
    String? appKey,
    String? buildNum,
  }) async {
    return InitResultInfo.fromJson({
      'isSuccess': true,
      'appId': '42',
      'message': 'ok',
    });
  }

  @override
  Future<Null> setUserId(String userId) async {}

  @override
  Future<Null> setUserTag(int userSceneTag) async {}

  @override
  Future<Null> putUserData(
      {required String key, required String value}) async {}

  @override
  Future<Null> uploadException({
    required String message,
    required String detail,
    String? type,
    Map? data,
  }) async {}

  @override
  Future<Null> setAppChannel(String channel) async {}

  @override
  Future<Null> setDeviceModel(String deviceModel) async {}

  @override
  Future<Null> setAppPackageName(String appPackage) async {}

  @override
  Future<Null> setAppVersion(String appVersion) async {}

  @override
  Future<Null> setDeviceID(String deviceId) async {}

  @override
  Future<Null> log({
    required String tag,
    required String message,
    LogLevel level = LogLevel.INFO,
  }) async {}
}

void main() {
  final FlutterBuglyProPlatform initialPlatform =
      FlutterBuglyProPlatform.instance;

  test('$MethodChannelFlutterBuglyPro is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBuglyPro>());
  });

  test('platform instance can be replaced with a mock', () {
    final MockFlutterBuglyProPlatform mock = MockFlutterBuglyProPlatform();
    FlutterBuglyProPlatform.instance = mock;
    expect(FlutterBuglyProPlatform.instance, same(mock));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro_platform_interface.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBuglyProPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBuglyProPlatform {
  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void init(
      {required String iOSAppId,
      required String androidAppId,
      String? channel}) {}

  @override
  void setUserIdentifier(String userId) {}

  @override
  void reportException(
      {required String exception, required String stackTrace}) {}
}

void main() {
  final FlutterBuglyProPlatform initialPlatform =
      FlutterBuglyProPlatform.instance;

  test('$MethodChannelFlutterBuglyPro is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBuglyPro>());
  });

  // test('getPlatformVersion', () async {
  // FlutterBuglyPro flutterBuglyProPlugin = FlutterBuglyPro();
  // MockFlutterBuglyProPlatform fakePlatform = MockFlutterBuglyProPlatform();
  // FlutterBuglyProPlatform.instance = fakePlatform;
  //
  // expect(await flutterBuglyProPlugin.getPlatformVersion(), '42');
  // });
}

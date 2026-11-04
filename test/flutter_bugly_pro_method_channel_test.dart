import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MethodChannelFlutterBuglyPro platform = MethodChannelFlutterBuglyPro();
  final List<MethodCall> calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      platform.methodChannel,
      (MethodCall methodCall) async {
        calls.add(methodCall);
        if (methodCall.method == 'initBugly') {
          return '{"isSuccess":true,"appId":"app","message":"ok"}';
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('init sends the official initBugly protocol', () async {
    final InitResultInfo result = await platform.init(
      androidAppId: 'android',
      iOSAppId: 'ios',
      channel: 'channel',
    );

    expect(result.isSuccess, isTrue);
    expect(result.appId, 'app');
    expect(calls.single.method, 'initBugly');
    final Map<dynamic, dynamic> arguments = calls.single.arguments as Map;
    expect(arguments.containsKey('appId'), isTrue);
    expect(arguments['channel'], 'channel');
    expect(arguments['initDelay'], 0);
    expect(arguments['debugMode'], kDebugMode);
    expect(arguments.containsKey('deviceId'), isTrue);
    expect(arguments.containsKey('appKey'), isTrue);
    expect(arguments.keys.length, 19);
  });

  test('user methods send official protocol', () async {
    await platform.setUserId('u');
    await platform.setUserTag(7);
    await platform.putUserData(key: 'k', value: 'v');
    await platform.uploadException(
      message: 'm',
      detail: 'd',
      type: 't',
      data: {'a': 'b'},
    );
    await platform.setAppChannel('c');
    await platform.setDeviceModel('dm');
    await platform.setAppPackageName('p');
    await platform.setAppVersion('av');
    await platform.setDeviceID('d');
    await platform.log(tag: 'tag', message: 'msg', level: LogLevel.INFO);

    expect(calls.map((MethodCall call) => call.method).toList(), <String>[
      'setUserId',
      'setUserTag',
      'putUserData',
      'postCatchedException',
      'setAppChannel',
      'setDeviceModel',
      'setAppPackageName',
      'setAppVersion',
      'setDeviceID',
      'log',
    ]);

    expect(calls[0].arguments, <String, Object>{'userId': 'u'});
    expect(calls[1].arguments, <String, Object>{'userTag': 7});
    expect(calls[2].arguments, <String, Object>{'key': 'k', 'value': 'v'});
    final Map<dynamic, dynamic> exceptionArgs = calls[3].arguments as Map;
    expect(exceptionArgs['crash_message'], 'm');
    expect(exceptionArgs['crash_detail'], 'd');
    expect(exceptionArgs['crash_type'], 't');
    expect(exceptionArgs['crash_data'], <String, String>{'a': 'b'});
    expect(calls[4].arguments, <String, Object>{'channel': 'c'});
    expect(calls[5].arguments, <String, Object>{'deviceModel': 'dm'});
    expect(calls[6].arguments, <String, Object>{'appPackage': 'p'});
    expect(calls[7].arguments, <String, Object>{'appVersion': 'av'});
    expect(calls[8].arguments, <String, Object>{'deviceId': 'd'});
    expect(calls[9].arguments, <String, Object>{
      'log_level': 3,
      'log_tag': 'tag',
      'log_message': 'msg',
    });
  });
}

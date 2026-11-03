import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bugly_pro_platform_interface.dart';

/// An implementation of [FlutterBuglyProPlatform] that uses method channels.
class MethodChannelFlutterBuglyPro extends FlutterBuglyProPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bugly_pro');

  @override
  void init(
      {required String iOSAppId,
      required String androidAppId,
      String? channel}) {
    // 先将 onError 保存起来
    var onError = FlutterError.onError;
    // onError是FlutterError的一个静态属性，它有一个默认的处理方法 dumpErrorToConsole
    FlutterError.onError = (errorDetails) {
      reportException(
          exception: "${errorDetails.exception}",
          stackTrace: "${errorDetails.stack}");
      // 调用默认的onError处理
      onError?.call(errorDetails);
    };
    // 官方推荐使用
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      reportException(exception: "$exception", stackTrace: "$stackTrace");
      if (kDebugMode) {
        print("$exception\n$stackTrace");
      }
      return true;
    };
    methodChannel.invokeMethod('init', {
      "appId": Platform.isAndroid ? androidAppId : iOSAppId,
      'channel': channel,
    });
  }

  @override
  void setUserIdentifier(String userId) {
    methodChannel.invokeMethod('setUserIdentifier', {"userId": userId});
  }

  @override
  void reportException(
      {required String exception, required String stackTrace}) {
    if (!kDebugMode) {
      methodChannel.invokeMethod('reportException', {
        "exception": exception,
        "stackTrace": stackTrace,
      });
    }
  }
}

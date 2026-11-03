import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bugly_pro_method_channel.dart';

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

  void init({required String iOSAppId, required String androidAppId, String? channel}) {
    throw UnimplementedError('init() has not been implemented.');
  }

  void setUserIdentifier(String userId) {
    throw UnimplementedError('setUserIdentifier() has not been implemented.');
  }

  void reportException({required String exception, required String stackTrace}) {
    throw UnimplementedError('reportException() has not been implemented.');
  }
}

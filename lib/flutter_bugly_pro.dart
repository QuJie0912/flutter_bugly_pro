import 'flutter_bugly_pro_platform_interface.dart';

class FlutterBuglyPro {
  static void init(
      {required String iOSAppId,
      required String androidAppId,
      String? channel}) {
    FlutterBuglyProPlatform.instance
        .init(iOSAppId: iOSAppId, androidAppId: androidAppId, channel: channel);
  }

  static void setUserIdentifier(String userId) {
    FlutterBuglyProPlatform.instance.setUserIdentifier(userId);
  }

  static void reportException(
      {required String exception, required String stackTrace}) {
    FlutterBuglyProPlatform.instance
        .reportException(exception: exception, stackTrace: stackTrace);
  }
}

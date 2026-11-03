import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_bugly_pro/flutter_bugly_pro.dart';

import 'app.dart';

void main() async {
  await initEasyApp(
    appBaseURLChangedCallback: () {},
  );
  await initApp();
  runApp(const MyApp());
  if (isAndroid) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Set overlay style status bar. It must run after MyApp(), because MaterialApp may override it.
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

Future<void> initApp() async {
  // TODO: set appId
  FlutterBuglyPro.init(iOSAppId: '', androidAppId: '', channel: appChannel);
}

# flutter_bugly_pro

为移动开发者提供专业的异常上报和运营统计，帮助开发者快速发现并解决异常，同时掌握产品运营动态，及时跟进用户反馈

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## iOS Simulator

Bugly 2.6.1 does not provide an arm64 iOS Simulator slice. This plugin keeps
the official Bugly dependency for device builds and automatically links a
no-op simulator stub instead. No Podfile changes or excluded architectures are
required in the host application.

# flutter_bugly_pro

基于腾讯 Bugly SDK 封装的 Flutter 插件，提供异常上报、运营统计能力，帮助快速定位线上异常，追踪产品运营数据。

支持 Android、iOS。

✅ **iOS 模拟器适配说明**
Bugly 2.6.1 官方 SDK 不提供 arm64 模拟器切片。本插件内置自动 Stub 脚本：
- 真机：使用完整官方 Bugly SDK，上报功能正常；
- iOS 模拟器：自动链接空实现 stub，**仅绕过编译链接报错，所有 Bugly 接口无实际上报能力**，无需在项目 Podfile 排除 arm64 架构，不影响其他第三方库编译。

## Getting Started

### 引入依赖
```yaml
dependencies:
  flutter_bugly_pro:
    git:
      url: https://github.com/QuJie0912/flutter_bugly_pro
      ref: main
```

### 基础使用

```dart
// 初始化
final InitResultInfo result = await FlutterBuglyPro.init(
  androidAppId: "你的 Android AppId",
  iOSAppId: "你的 iOS AppId",
  channel: "渠道名",
);

// 上报自定义异常
await FlutterBuglyPro.uploadException(
  message: "异常信息",
  detail: stackTrace.toString(),
);

// 自动捕获异常
FlutterBuglyPro.postCatchedException(() {
  runApp(const MyApp());
});
```

> iOS 原生仅实现 `init`、`postCatchedException`（对应 `uploadException`）、`setUserId`、`setUserTag`、`setAppVersion`、`putUserData`、`log`；
> `setAppChannel`、`setDeviceModel`、`setAppPackageName`、`setDeviceID` 在 iOS 上抛 `MissingPluginException`（与官方行为一致，仅 Android 可用）。

## iOS 模拟器适配原理
Bugly 2.6.1 版本没有提供 arm64 架构的 iOS 模拟器切片。
本插件在编译真机包时继续依赖官方原版 Bugly SDK，编译模拟器时自动链接无操作的空桩（stub）实现。
宿主工程无需修改 Podfile，也不用配置排除架构。

> 提示：调试异常上报功能，请使用 iOS 真机。

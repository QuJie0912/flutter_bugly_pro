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
公开 API 的方法名、参数名、类型、默认值、返回值与官方 `flutter_bugly` 1.1.1 逐项一致（类名保留为 `FlutterBuglyPro`）；内部行为存在三处有意差异，详见下文“与官方 1.1.1 的有意差异”。

```dart
// 初始化
final InitResultInfo result = await FlutterBuglyPro.init(
  androidAppId: "你的 Android AppId",
  iOSAppId: "你的 iOS AppId",
  channel: "渠道名",
  // 卡顿监控默认开启（与官方 1.1.1 一致）；此处显式写法仅为可读性
  enableBlockMonitor: true,
);
// 设置用户标识
await FlutterBuglyPro.setUserId("xxx");
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

## 与官方 flutter_bugly 1.1.1 的有意差异

对外 API（方法名、参数名、类型、默认值、返回值）与官方 1.1.1 保持一致；以下三处为有意差异（官方内部缺陷修正）：

| 差异 | 官方 1.1.1 行为 | 本插件行为 | 影响 |
|---|---|---|---|
| iOS 卡顿开关键名 | 读 `blockMonitorEnable`，但 Dart 发送的是 `enableBlockMonitor`，开关始终关闭 | 读取 `enableBlockMonitor` | iOS 卡顿监控按参数真正生效：`enableBlockMonitor` 默认 `true`（与官方 Dart 默认值一致），因此 iOS 默认开启；官方因键名拼错，即使 Dart 默认 `true` 实际也不生效。这是本插件与官方最明显的运行时行为差异 |
| iOS 卡顿阈值 | `init` 未读取 `blockMonitorTimeout` | 读取并设置 `BuglyConfig.blockMonitorTimeout`；单位为秒，缺失或 ≤0 回落 3 | iOS 卡顿阈值真正生效 |
| Android 空 detail 上报 | `crash_detail` 为空时直接 return，不上报 | 归一化为空字符串后仍调用 `CrashReport.postException(8, ...)` | 空堆栈的自定义异常也会上报，与 iOS 行为一致 |

除以上三处外，其余内部行为尽量保持与官方一致：`initDelay` 仍按毫秒原值传递、iOS 仍用空字符串分隔调用栈、Android category 8 / iOS category 5 等均未改变。切回官方库后，上述三处行为会回退为官方实现（包括 iOS 卡顿监控因键名 bug 实际不开启）。

`enableBlockMonitor` 默认值为 `true`，与官方 Dart 一致；该值集中在 [src/defaults.dart](lib/src/defaults.dart)，Dart 入口、平台接口、通道实现三处签名统一引用。Android 侧当前不读取该参数（与官方一致），仅在 iOS 生效。

## iOS 模拟器适配原理
Bugly 2.6.1 版本没有提供 arm64 架构的 iOS 模拟器切片。
本插件在编译真机包时继续依赖官方原版 Bugly SDK，编译模拟器时自动链接无操作的空桩（stub）实现。
宿主工程无需修改 Podfile，也不用配置排除架构。

> 提示：调试异常上报功能，请使用 iOS 真机。

## 溯源说明
本插件 Fork 自 [flutter_easy_bugly](原仓库地址)，在原有基础上修复自定义异常上报问题，保留 iOS Simulator Stub 编译绕过方案。
本项目为第三方衍生封装，非腾讯 Bugly 官方插件。

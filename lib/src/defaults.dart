/// 卡顿监控开关的默认值。
///
/// 与官方 flutter_bugly 1.1.1 的 Dart 默认值保持一致（`true`）。
/// 注意：官方 iOS 因读取错误的键名（`blockMonitorEnable`）导致该开关实际不生效；
/// 本插件已修正为读取 Dart 实际发送的 `enableBlockMonitor`，因此默认值会真正生效。
const bool defaultEnableBlockMonitor = true;

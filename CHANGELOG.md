* ## 1.0.2

* 修复：
  * iOS 异常上报在 `crash_detail` 为空时不再清空 `crash_message`，改为传入空调用栈，保证无堆栈事件仍可读。
  * iOS 异常上报在 `crash_type` 缺失时使用稳定默认分类 `FlutterEvent`；`crash_message` 缺失时回落为分类名，避免空 `name`/`reason`。
  * iOS 调用栈改为按换行拆分并过滤空行，`callStack` 类型统一为 `[String]`，与 Bugly 接口一致。

* ## 1.0.1

* iOS 增加受条件编译保护的 Bugly 桥接层，模拟器保持编译通过且不调用 Bugly 原生接口。
* 功能完善：
  * iOS 改读 `enableBlockMonitor`，卡顿监控开关。
  * iOS 接入 `blockMonitorTimeout`，卡顿阀值（单位秒，缺失或 ≤0 回落 3）。
  * Android `detail` 为空时归一化为空字符串后仍上报，不再静默丢弃。

* ## 1.0.0

* initial release.

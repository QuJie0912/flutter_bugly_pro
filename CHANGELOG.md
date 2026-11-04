* ## 1.0.1

* iOS 增加受条件编译保护的 Bugly 桥接层，模拟器保持编译通过且不调用 Bugly 原生接口。
* 功能完善：
  * iOS 改读 `enableBlockMonitor`，卡顿监控开关。
  * iOS 接入 `blockMonitorTimeout`，卡顿阀值（单位秒，缺失或 ≤0 回落 3）。
  * Android `detail` 为空时归一化为空字符串后仍上报，不再静默丢弃。

* ## 1.0.0

* initial release.

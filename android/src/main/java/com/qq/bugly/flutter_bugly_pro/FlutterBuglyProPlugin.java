package com.qq.bugly.flutter_bugly_pro;

import android.annotation.SuppressLint;
import androidx.annotation.NonNull;
import android.app.Activity;

import io.flutter.BuildConfig;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.tencent.bugly.crashreport.CrashReport;

/** FlutterBuglyProPlugin */
public class FlutterBuglyProPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  @SuppressLint("StaticFieldLeak")
  private static Activity activity;
  private FlutterPluginBinding flutterPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    flutterPluginBinding = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      String appId = call.argument("appId");
      String channel = call.argument("channel");
      CrashReport.setAppChannel(activity.getApplicationContext(), channel);
      CrashReport.initCrashReport(activity.getApplicationContext(), appId, BuildConfig.DEBUG);
    } else if (call.method.equals("reportException")) {
      String exception = call.argument("exception");
      String stackTrace = call.argument("stackTrace");
      CrashReport.postException(8, exception, "Flutter Exception", stackTrace, null);
    } else if (call.method.equals("setUserIdentifier")) {
      String userId = call.argument("userId");
      CrashReport.setUserId(activity.getApplicationContext(), userId);
    } else {
      result.notImplemented();
    }
  }

  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_bugly_pro");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}

package com.qq.bugly.flutter_bugly_pro;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.junit.Test;

public class FlutterBuglyProPluginTest {
    @Test
    public void onMethodCall_unknownMethod_returnsNotImplemented() {
        FlutterBuglyProPlugin plugin = new FlutterBuglyProPlugin();
        MethodChannel.Result result = mock(MethodChannel.Result.class);

        plugin.onMethodCall(new MethodCall("unknown", null), result);

        verify(result).notImplemented();
    }
}

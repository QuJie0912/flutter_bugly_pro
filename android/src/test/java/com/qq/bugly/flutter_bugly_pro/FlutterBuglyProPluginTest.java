package com.qq.bugly.flutter_bugly_pro;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.verify;

import com.tencent.bugly.crashreport.CrashReport;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.junit.Test;
import org.mockito.MockedStatic;

import java.util.HashMap;
import java.util.Map;

public class FlutterBuglyProPluginTest {
    @Test
    public void onMethodCall_unknownMethod_returnsNotImplemented() {
        FlutterBuglyProPlugin plugin = new FlutterBuglyProPlugin();
        MethodChannel.Result result = mock(MethodChannel.Result.class);

        plugin.onMethodCall(new MethodCall("unknown", null), result);

        verify(result).notImplemented();
    }

    @Test
    public void onMethodCall_postCatchedException_emptyDetail_stillReports() {
        FlutterBuglyProPlugin plugin = new FlutterBuglyProPlugin();
        MethodChannel.Result result = mock(MethodChannel.Result.class);

        Map<String, Object> arguments = new HashMap<>();
        arguments.put("crash_type", "t");
        arguments.put("crash_message", "m");
        arguments.put("crash_detail", "");
        Map<String, String> data = new HashMap<>();
        data.put("k", "v");
        arguments.put("crash_data", data);

        try (MockedStatic<CrashReport> crashReport = mockStatic(CrashReport.class)) {
            plugin.onMethodCall(new MethodCall("postCatchedException", arguments), result);

            crashReport.verify(() -> CrashReport.postException(eq(8), eq("t"), eq("m"), eq(""), any()));
        }

        verify(result).success(null);
    }
}

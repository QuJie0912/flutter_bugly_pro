#import "BuglyLogBridge.h"

#import <TargetConditionals.h>

#if !TARGET_OS_SIMULATOR
#import <Bugly/BuglyLog.h>
#endif

void BuglyLogBridgeLog(NSInteger level, NSString * _Nullable tag, NSString * _Nullable message) {
#if !TARGET_OS_SIMULATOR
    switch (level) {
        case (long)BuglyLogLevelVerbose:
            [BuglyLog level:BuglyLogLevelVerbose tag:tag log:@"%@", message];
            break;
        case (long)BuglyLogLevelError:
            [BuglyLog level:BuglyLogLevelError tag:tag log:@"%@", message];
            break;
        case (long)BuglyLogLevelWarn:
            [BuglyLog level:BuglyLogLevelWarn tag:tag log:@"%@", message];
            break;
        case (long)BuglyLogLevelInfo:
            [BuglyLog level:BuglyLogLevelInfo tag:tag log:@"%@", message];
            break;
        case (long)BuglyLogLevelDebug:
            [BuglyLog level:BuglyLogLevelDebug tag:tag log:@"%@", message];
            break;
        default:
            [BuglyLog level:BuglyLogLevelSilent tag:tag log:@"%@", message];
            break;
    }
#endif
}

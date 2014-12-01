
#import <Cocoa/Cocoa.h>
#import "macros.h"

@interface GDCrashFinder : NSObject {
	
}

+ (NSString * ) getLatestCrashReportForApplication:(NSString *) anAppName;

@end

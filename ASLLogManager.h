
#import <Cocoa/Cocoa.h>

@class ASLLog;

/**
 * The ASLLogManager manages ASLLog objects.
 *
 * Here's an extracted example:
 * @code
 * ASLLogManager * logManager = [ASLLogManager sharedInstance];
 * ASLLog * log = [[ASLLog alloc] initWithSender:@"MyAppName" facility:@"my.company.AppName" connectImmediately:TRUE];
 * [log setLogFile:@"/var/log/MyApp"];
 * [log info:@"TEST"];
 * [logManager setLog:log forKey:@"main"];
 *
 * //pull out the log:
 * ASLLog * mainLog = [ASLLogManager getLogForKey:@"main"];
 * [mainLog info:@"TEST2"];
 * @endcode
 */
@interface ASLLogManager : NSObject
@property BOOL enabled;
+ (ASLLogManager *) sharedInstance;
- (void) setLog:(ASLLog *) log forKey:(NSString *) key;
- (ASLLog *) getLogForKey:(NSString *) key;
@end

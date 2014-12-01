//copyright 2009 aaronsmith

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
@interface ASLLogManager : NSObject {
	
	Boolean enabled;
	
	/**
	 * Lookup for any stored log objects.
	 */
	NSMutableDictionary * logs;
}

/**
 * Whether or not logging is enabled. You can
 * toggle this to disable or enable all ASLLog
 * instances - they're just disabled, not
 * destroyed.
 */
@property (assign) Boolean enabled;

/**
 * Singleton instance.
 */
+ (ASLLogManager *) sharedInstance;

/**
 * Set a log object for key.
 *
 * @param log The ASLLog to save.
 * @param key The key to store it with.
 */
- (void) setLog:(ASLLog *) log forKey:(NSString *) key;

/**
 * Get a log object by key.
 *
 * @param key The key the log was saved with.
 */
- (ASLLog *) getLogForKey:(NSString *) key;

@end

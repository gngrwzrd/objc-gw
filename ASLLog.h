
#include <asl.h>
#import <Cocoa/Cocoa.h>
#import "ASLLogManager.h"

@class ASLLogManager;

//The ASLLog is a wrapper around Apple's system log facility (man asl).
@interface ASLLog : NSObject {
	
}

//Whether or not to log all messages to stdout as well.
@property (assign) Boolean logToStdOut;

//Designated initializer.
//Here's an extracted example:
//ASLLog * log = [[ASLLog alloc] initWithSender:@"MyAppName" facility:@"my.company.AppName" connectImmediately:TRUE];
//[log setLogFile:@"/var/log/MyApp"];
//[log info:@"TEST"];
- (id) initWithSender:(NSString *) sender facility:(NSString *) facility connectImmediately:(Boolean) connectImmediately;

- (int) setLogFile:(NSString *) filePath;
- (void) alert:(NSString *) message;
- (void) critical:(NSString *) message;
- (void) debug:(NSString *) message;
- (void) emergency:(NSString *) message;
- (void) error:(NSString *) message;
- (void) info:(NSString *) message;
- (void) notice:(NSString *) message;
- (void) warning:(NSString *) message;
- (void) close;

@end

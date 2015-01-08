
#import <Cocoa/Cocoa.h>

//Use this in a commandline tool to connect to a CliProxy in a cocoa app.
@interface CliProxyConnector : NSObject
@property Protocol * distantProtocol;
- (NSDistantObject *) getDistantObjectInApplication:(NSString *) bundleIdentifier withConnectionName:(NSString *) connectionName andLaunchAppIfNotAvailable:(BOOL) launch;
@end

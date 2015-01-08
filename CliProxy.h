
#import <Cocoa/Cocoa.h>

//The CliProxy is the host proxy you use inside of your cocoa application that needs
//to expose some usage from the commandline. Then use CliProxyConnector inside of
//your commandline tool to connect to this proxy.

@interface CliProxy : NSObject
@property NSConnection * connection;
- (void) connectWithConnectionName:(NSString *) connectionName;
@end

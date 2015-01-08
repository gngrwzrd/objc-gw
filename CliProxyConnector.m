
#import "CliProxyConnector.h"

@interface CliProxyConnector ()
@end

@implementation CliProxyConnector

- (NSDistantObject *) connectWithName:(NSString *) _connectionName {
	NSDistantObject * proxy = [NSConnection rootProxyForConnectionWithRegisteredName:_connectionName host:nil];
	return proxy;
}

- (NSDistantObject *) getDistantObjectInApplication:(NSString *) bundleIdentifier withConnectionName:(NSString *) connectionName andLaunchAppIfNotAvailable:(BOOL) launch {
	if(launch) {
		[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:bundleIdentifier options:0 additionalEventParamDescriptor:nil launchIdentifier:nil];
	}
	NSDistantObject * proxy = [self connectWithName:connectionName];
	if(proxy && self.distantProtocol) {
		[proxy setProtocolForProxy:self.distantProtocol];
		return proxy;
	}
	return nil;
}

@end

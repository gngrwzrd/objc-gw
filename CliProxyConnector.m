
#import "CliProxyConnector.h"

@interface CliProxyConnector ()
@property (nonatomic) Protocol * distantProtocol;
@end

@implementation CliProxyConnector

- (NSDistantObject *) connectWithName:(NSString *) _connectionName {
	NSDistantObject * proxy = [NSConnection rootProxyForConnectionWithRegisteredName:_connectionName host:nil];
	return proxy;
}

- (NSDistantObject *) getDistantObjectInApplication:(NSString *) bundleIdentifier withConnectionName:(NSString *) connectionName andLaunchAppIfNotAvailable:(BOOL) launch {
	NSDistantObject * proxy = [self connectWithName:connectionName];
	if(proxy) {
		if(self.distantProtocol) {
			[proxy setProtocolForProxy:self.distantProtocol];
		}
		return proxy;
	}
	if(!launch) {
		return nil;
	}
	[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:bundleIdentifier options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifier:nil];
	for(int c = 0; proxy==nil && c < 50; c++) {
		proxy = [self connectWithName:connectionName];
		if(proxy) {
			break;
		}
		usleep(15000);
	}
	if(proxy) {
		if(self.distantProtocol) {
			[proxy setProtocolForProxy:self.distantProtocol];
		}
		return proxy;
	}
	return nil;
}

- (void) setDistantProtocol:(Protocol *) protocol {
	self.distantProtocol = protocol;
}

@end

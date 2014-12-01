
#import "CliProxy.h"

@implementation CliProxy

- (void) connectWithConnectionName:(NSString *) connectionName {
	self.connection = [[NSConnection alloc] init];
	[self.connection setRootObject:self];
	[self.connection registerName:connectionName];
}

@end

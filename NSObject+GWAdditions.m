
#import "NSObject+GWAdditions.h"

@implementation NSObject (GWAdditions)

- (id) gw_ifRespondsPerformSelector:(SEL) selector {
	if([self respondsToSelector:selector]) return [self performSelector:selector];
	return nil;
}

- (id) gw_ifRespondsPerformSelector:(SEL) selector withObject:(id) object {
	if([self respondsToSelector:selector]) return [self performSelector:selector withObject:object];
	return nil;
}

@end

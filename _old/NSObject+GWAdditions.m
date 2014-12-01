
#import "NSObject+GWAdditions.h"
#import "gwmacros.h"

@implementation NSObject (GWAdditions)

- (id) gw_ifRespondsPerformSelector:(SEL) selector {
	SuppressPerformSelectorLeakWarning(
		if([self respondsToSelector:selector]) return [self performSelector:selector];
	);
	return nil;
}

- (id) gw_ifRespondsPerformSelector:(SEL) selector withObject:(id) object {
	SuppressPerformSelectorLeakWarning(
		if([self respondsToSelector:selector]) return [self performSelector:selector withObject:object];
	);
	return nil;
}

@end

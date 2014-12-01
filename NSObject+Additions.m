
#import "NSObject+Additions.h"
#import "PragmaHelpers.h"

IgnorePerformSelectorLeakWarningPush

@implementation NSObject (Additions)

- (void) performSelectorIfResponds:(SEL) selector; {
	if([self respondsToSelector:selector]) {
		[self performSelector:selector];
	}
}

- (void) performSelectorIfResponds:(SEL) selector withObject:(id) object; {
	if([self respondsToSelector:selector]) {
		[self performSelector:selector withObject:object];
	}
}

- (void) performSelectorIfConforms:(Protocol *) protocol andResponds:(SEL) selector; {
	if([self conformsToProtocol:protocol] && [self respondsToSelector:selector]) {
		[self performSelector:selector];
	}
}

- (void) performSelectorIfConforms:(Protocol *) protocol andResponds:(SEL) selector withObject:(id) object; {
	if([self conformsToProtocol:protocol] && [self respondsToSelector:selector]) {
		[self performSelector:selector withObject:object];
	}
}

IgnorePerformSelectorLeakWarningPop

@end

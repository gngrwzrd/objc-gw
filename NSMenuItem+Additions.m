
#import "NSMenuItem+Additions.h"

@implementation NSMenuItem (Additions)

+ (NSMenuItem *) separatorItemWithTag:(NSUInteger) tag; {
	NSMenuItem * item = [NSMenuItem separatorItem];
	item.tag = tag;
	return item;
}

- (void) removeFromContainingMenu; {
	[self.menu removeItem:self];
}

@end


#import "NSMenuItem+Additions.h"

@implementation NSMenuItem (Additions)

- (void) removeFromContainingMenu; {
	[self.menu removeItem:self];
}

@end

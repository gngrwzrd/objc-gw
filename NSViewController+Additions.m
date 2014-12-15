
#import "NSViewController+Additions.h"

@implementation NSViewController (Additions)

- (void) loadViewSafely; {
	__unused NSView * view = self.view;
}

@end

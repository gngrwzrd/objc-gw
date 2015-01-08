
#import "NSMenu+Additions.h"

@implementation NSMenu (Additions)

- (void) setAllItemsEnabled:(BOOL) enabled; {
	NSArray * items = self.itemArray;
	for(NSMenuItem * item in items) {
		if(item.isSeparatorItem) {
			continue;
		}
		[item setEnabled:enabled];
	}
}

- (void) setEnabled:(BOOL) enabled forItemsWithTagsInRange:(NSRange) range; {
	NSArray * items = self.itemArray;
	for(NSMenuItem * item in items) {
		if(NSLocationInRange(item.tag,range)) {
			[item setEnabled:enabled];
		}
	}
}

- (void) removeItemsWithTagsInRange:(NSRange) range; {
	NSArray * items = self.itemArray;
	for(NSMenuItem * item in items) {
		if(NSLocationInRange(item.tag,range)) {
			[self removeItem:item];
		}
	}
}

- (void) removeItemsWithTag:(NSUInteger) tag; {
	NSArray * items = self.itemArray;
	for(NSMenuItem * item in items) {
		if(item.tag == tag) {
			[self removeItem:item];
		}
	}
}

@end

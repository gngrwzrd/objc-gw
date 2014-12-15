
#import <Cocoa/Cocoa.h>

@interface NSMenu (Additions)

- (void) setAllItemsEnabled:(BOOL) enabled;
- (void) setEnabled:(BOOL) enabled forItemsWithTagsInRange:(NSRange) range;
- (void) removeItemsWithTagsInRange:(NSRange) range;
- (void) removeItemsWithTag:(NSUInteger) tag;

@end

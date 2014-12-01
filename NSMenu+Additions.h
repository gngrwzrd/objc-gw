
#import <Cocoa/Cocoa.h>

@interface NSMenu (Additions)
- (void) setAllItemsEnabled:(BOOL) enabled;
- (void) setEnabled:(BOOL)enabled forItemsWithTagsInRange:(NSRange) range;;
@end

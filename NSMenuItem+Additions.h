
#import <Cocoa/Cocoa.h>

@interface NSMenuItem (Additions)

+ (NSMenuItem *) separatorItemWithTag:(NSUInteger) tag;
- (void) removeFromContainingMenu;

@end


#import <Cocoa/Cocoa.h>

@interface NSView (AutoResizing)
- (void) fixLeftEdge:(BOOL) fixed;
- (void) fixRightEdge:(BOOL) fixed;
- (void) fixTopEdge:(BOOL) fixed;
- (void) fixBottomEdge:(BOOL) fixed;
- (void) fixWidth:(BOOL) fixed;
- (void) fixHeight:(BOOL) fixed;
@end

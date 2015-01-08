
#import <Cocoa/Cocoa.h>

@interface CursorButton : NSButton
@property NSRect cursorRect;
@property NSCursor * cursor;
- (void) setCursor:(NSCursor *) cursor cursorRect:(NSRect) cursorRect;
@end

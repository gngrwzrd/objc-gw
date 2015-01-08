
#import "CursorButton.h"

@implementation CursorButton

- (void) resetCursorRects {
	[super resetCursorRects];
	if(self.cursor ) {
		[self removeCursorRect:self.cursorRect cursor:self.cursor];
	}
	[self addCursorRect:self.cursorRect cursor:self.cursor];
}

- (void) setCursor:(NSCursor *) cursor cursorRect:(NSRect) cursorRect; {
	self.cursor = cursor;
	self.cursorRect = cursorRect;
}

@end

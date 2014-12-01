
#import "GWCursorButton.h"

@implementation GWCursorButton

- (void) resetCursorRects {
	[super resetCursorRects];
	if(self.cursor ) {
		[self removeCursorRect:self.cursorRect cursor:self.cursor];
	}
	[self addCursorRect:self.cursorRect cursor:self.cursor];
}

@end

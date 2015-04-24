
#import "NSView+Helpers.h"

@implementation NSView (Helpers)

- (void) setWidth:(CGFloat) width {
	NSRect f = self.frame;
	f.size.width = width;
	self.frame = f;
}

- (void) setHeight:(CGFloat) height {
	NSRect f = self.frame;
	f.size.height = height;
	self.frame = f;
}

- (void) setX:(CGFloat) x {
	NSRect f = self.frame;
	f.origin.x = x;
	self.frame = f;
}

- (void) setY:(CGFloat) y {
	NSRect f = self.frame;
	f.origin.y = y;
	self.frame = f;
}

- (CGFloat) x {
	return NSMinX(self.frame);
}

- (CGFloat) y {
	return NSMinY(self.frame);
}

- (CGFloat) width {
	return NSWidth(self.frame);
}

- (CGFloat) height {
	return NSHeight(self.frame);
}

@end

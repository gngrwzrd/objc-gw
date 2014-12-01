
#import "NSScreen+Additions.h"

@implementation NSScreen (Additions)
+ (NSScreen *) screenContainingPoint:(NSPoint) point; {
	NSArray * screens = [NSScreen screens];
	for(NSScreen * screen in screens) {
		NSRect visibleFrame = screen.visibleFrame;
		if(NSPointInRect(point,visibleFrame)) {
			return screen;
		}
	}
	return NULL;
}

+ (NSScreen *) screenContainingRect:(NSRect) rect {
	NSArray * screens = [NSScreen screens];
	for(NSScreen * screen in screens) {
		NSRect visibleFrame = screen.visibleFrame;
		if(NSContainsRect(visibleFrame,rect)) {
			return screen;
		}
	}
	return NULL;
}

- (NSSize) pixelDimensions {
	NSValue * sizeValue = [[self deviceDescription] objectForKey:@"NSDeviceSize"];
	return [sizeValue sizeValue];
}

- (CGDirectDisplayID) displayId; {
	return (CGDirectDisplayID)[[[self deviceDescription] objectForKey:@"NSScreenNumber"] unsignedIntegerValue];
}

@end


#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface NSScreen (Additions)
+ (NSScreen *) screenContainingPoint:(NSPoint) point;
+ (NSScreen *) screenContainingRect:(NSRect) rect;
- (NSSize) pixelDimensions;
- (CGDirectDisplayID) displayId;
@end

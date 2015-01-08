
#import <Cocoa/Cocoa.h>

@interface NSBezierPath (BezierPathQuartzUtilities)

//get a CGPathRef from an NSBezierPath
//This method works only in OS X v10.2 and later.
- (CGPathRef) quartzPath;

@end

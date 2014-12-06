
#import <Cocoa/Cocoa.h>

@interface QuartzDisplay : NSObject
@property CGDirectDisplayID displayId;
+ (NSUInteger) numberOfDisplays;
+ (NSArray *) displays;
- (id) initWithCGDirectDisplayId:(CGDirectDisplayID) directDisplayId;
- (id) initWithPoint:(NSPoint) point;
- (id) initWithRect:(NSRect) rect;
- (BOOL) isEqualToDisplay:(QuartzDisplay *) display;
- (NSString *) serialNumber;
- (NSScreen *) screen;
- (NSString *) vendorNumber;
- (NSString *) unitNumber;
- (NSString *) serialAndVendorAndUnit;
- (NSSize) pixelSize;
- (NSRect) bounds;
@end

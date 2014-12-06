
#import <Cocoa/Cocoa.h>

@interface QuartzDisplay : NSObject
@property CGDirectDisplayID displayId;
+ (NSUInteger) numberOfDisplays;
- (id) initWithPoint:(NSPoint) point;
- (id) initWithRect:(NSRect) rect;
- (BOOL) isEqualToDisplay:(QuartzDisplay *) display;
- (NSString *) serialNumber;
- (NSSize) pixelSize;
- (NSScreen *) screen;
- (NSString *) vendorNumber;
- (NSString *) unitNumber;
- (NSString *) serialAndVendorAndUnit;
@end

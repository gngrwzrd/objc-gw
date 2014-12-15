
#import <Cocoa/Cocoa.h>

@interface NSColor (Additions)
+ (NSColor *) colorWithHexColorString:(NSString *) hexColorString;
+ (NSColor *) colorWithHexColorString:(NSString *) hexColorString alpha:(CGFloat) alpha;
- (NSString *) hexValue;
@end


#import <Cocoa/Cocoa.h>

@interface TiledImage : NSImage
@property NSColor * patternImage;
+ (TiledImage *) tileImageNamed:(NSString *) name;
@end

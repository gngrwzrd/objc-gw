
#import <Cocoa/Cocoa.h>

@interface NinePartImage : NSImage

+ (NSArray *) sliceImageForDrawNine:(NSImage *) sourceImage cornerRectSize:(NSSize) cornerRectSize;
+ (instancetype) ninePartImageNamed:(NSString *) imageName cornerSize:(NSSize) cornerSize;
+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage cornerSize:(NSSize) cornerSize;

@end

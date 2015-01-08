
#import <Foundation/Foundation.h>

@interface GWImageSlicer : NSObject
+ (NSArray *) sliceImageForDrawThree:(NSImage *)sourceImage sliceSize:(NSSize)sliceSize vertical:(BOOL)vertical flipped:(BOOL)flipped;
@end

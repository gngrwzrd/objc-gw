
#import <Cocoa/Cocoa.h>
#import "NinePartImage.h"
#import "ThreePartImage.h"

@interface NSImage (SlicedImage)

+ (NinePartImage *) ninePartImageNamed:(NSString *)imageName cornerSize:(NSSize)cornerSize;
+ (ThreePartImage *) threePartVerticalImageNamed:(NSString *)imageName sliceAmount:(CGFloat)sliceAmount;
+ (ThreePartImage *) threePartHorizontalImageNamed:(NSString *)imageName sliceAmount:(CGFloat)sliceAmount;

@end

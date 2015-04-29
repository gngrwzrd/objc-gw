
#import <Cocoa/Cocoa.h>

@interface ThreePartImage : NSImage

+ (instancetype) threePartVerticalImageNamed:(NSString *) imageName sliceAmount:(CGFloat) sliceAmount;
+ (instancetype) threePartHorizontalImageNamed:(NSString *) imageName sliceAmount:(CGFloat) sliceAmount;

@end

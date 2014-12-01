
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "GWQuartzUtils.h"

//Category additions to UIImage
@interface UIImage (Additions)

//Get a UIColor instance from a point in the bitmap.
- (UIColor *) gw_colorForPixelAtPoint:(CGPoint) point;

//Get RGBA component values from a pixel location.
- (void) gw_rgbaComponents:(float *) components forPixelAtPoint:(CGPoint) point;

//Get RGB component values from a pixel location.
- (void) gw_rgbComponents:(float *) components forPixelAtPoint:(CGPoint) point;

@end

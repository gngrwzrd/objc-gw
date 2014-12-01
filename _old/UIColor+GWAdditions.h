
#import <UIKit/UIKit.h>

@interface UIColor (GWAdditions)

+ (UIColor *) gw_colorWithRGBNumber:(NSNumber *) number;
+ (UIColor *) gw_colorWithRGBNumber:(NSNumber *) number alpha:(CGFloat) alpha;
+ (UIColor *) gw_colorWithRGBANumber:(NSNumber *) number;
+ (UIColor *) gw_colorWithARGBNumber:(NSNumber *) number;

@end

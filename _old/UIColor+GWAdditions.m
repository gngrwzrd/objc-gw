
#import "UIColor+GWAdditions.h"

@implementation UIColor (GWAdditions)

+ (UIColor *) gw_colorWithRGBNumber:(NSNumber *) number {
	NSUInteger intValue = [number unsignedIntegerValue];
	if(intValue == 0) return [UIColor blackColor];
	float r = (float) ((intValue >> 16) & 0xFF) / 255.0f;
	float g = (float) ((intValue >> 8) & 0xFF) / 255.0f;
	float b = (float) ((intValue) & 0xFF) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *) gw_colorWithRGBNumber:(NSNumber *) number alpha:(CGFloat) alpha {
	NSUInteger intValue = [number unsignedIntegerValue];
	if(intValue == 0) return [UIColor blackColor];
	float r = (float) ((intValue >> 16) & 0xFF) / 255.0f;
	float g = (float) ((intValue >> 8) & 0xFF) / 255.0f;
	float b = (float) ((intValue) & 0xFF) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *) gw_colorWithRGBANumber:(NSNumber *) number {
	NSUInteger intValue = [number unsignedIntegerValue];
	if(intValue == 0) return [UIColor blackColor];
	float r = (float) ((intValue >> 24) & 0xFF) / 255.0f;
	float g = (float) ((intValue >> 16) & 0xFF) / 255.0f;
	float b = (float) ((intValue >> 8 ) & 0xFF) / 255.0f;
	float a = (float) ((intValue) & 0xFF) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *) gw_colorWithARGBNumber:(NSNumber *) number {
	NSUInteger intValue = [number unsignedIntegerValue];
	if(intValue == 0) return [UIColor blackColor];
	float a = (float) ((intValue >> 24) & 0xFF) / 255.0f;
	float r = (float) ((intValue >> 16) & 0xFF) / 255.0f;
	float g = (float) ((intValue >> 8 ) & 0xFF) / 255.0f;
	float b = (float) ((intValue) & 0xFF) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end

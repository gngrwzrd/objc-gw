
#import "UIImage+GWAdditions.h"

@implementation UIImage (GWAdditions)

- (UIColor *) gw_colorForPixelAtPoint:(CGPoint) point {
	UIColor * color = nil;
	CGImageRef inImage = [self CGImage];
	CGContextRef cgctx = CGCreateARGBBitmapContextFromImage(inImage);
	if(cgctx == NULL) return nil;
	size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}};
	CGContextDrawImage(cgctx, rect, inImage); 	
	unsigned char * data = CGBitmapContextGetData(cgctx);
	if(data != NULL) {
		int offset = 4*((w*round(point.y))+round(point.x));
		int alpha =  data[offset];
		int red = data[offset+1];
		int green = data[offset+2];
		int blue = data[offset+3];
		color=[UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
	}
	CGContextRelease(cgctx); 
	if(data) free(data);
	return color;
}

- (void) gw_rgbaComponents:(float *) components forPixelAtPoint:(CGPoint) point {
	CGImageRef inImage = [self CGImage];
	CGContextRef cgctx = CGCreateARGBBitmapContextFromImage(inImage);
	if(cgctx == NULL) return;
	size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}};
	CGContextDrawImage(cgctx, rect, inImage);
	unsigned char * data = CGBitmapContextGetData(cgctx);
	int red = 0;
	int green = 0;
	int blue = 0;
	int alpha = 0;
	if(data != NULL) {
		int offset = 4*((w*round(point.y))+round(point.x));
		alpha =  data[offset];
		red = data[offset+1];
		green = data[offset+2];
		blue = data[offset+3];
	}
	components[0] = red/255.0f;
	components[1] = green/255.0f;
	components[2] = blue/255.0f;
	components[3] = alpha/255.0f;
	CGContextRelease(cgctx); 
	if(data) free(data);
}

- (void) gw_rgbComponents:(float *) components forPixelAtPoint:(CGPoint) point {
	CGImageRef inImage = [self CGImage];
	CGContextRef cgctx = CGCreateARGBBitmapContextFromImage(inImage);
	if(cgctx == NULL) return;
	size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}};
	CGContextDrawImage(cgctx,rect,inImage);
	unsigned char * data = CGBitmapContextGetData(cgctx);
	int red = 0;
	int green = 0;
	int blue = 0;
	if(data != NULL) {
		int offset = 4*((w*round(point.y))+round(point.x));
		red = data[offset+1];
		green = data[offset+2];
		blue = data[offset+3];
	}
	components[0] = red/255.0f;
	components[1] = green/255.0f;
	components[2] = blue/255.0f;
	CGContextRelease(cgctx); 
	if(data) free(data);
}

@end

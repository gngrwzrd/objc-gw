
#import "NSImage+SlicedImage.h"

@implementation NSImage (SlicedImage)

+ (NinePartImage *) ninePartImageNamed:(NSString *)imageName cornerSize:(NSSize)cornerSize; {
	return [NinePartImage ninePartImageNamed:imageName cornerSize:cornerSize];
}

+ (ThreePartImage *) threePartVerticalImageNamed:(NSString *)imageName sliceAmount:(CGFloat)sliceAmount; {
	return [ThreePartImage threePartVerticalImageNamed:imageName sliceAmount:sliceAmount];
}

+ (ThreePartImage *) threePartHorizontalImageNamed:(NSString *)imageName sliceAmount:(CGFloat)sliceAmount; {
	return [ThreePartImage threePartHorizontalImageNamed:imageName sliceAmount:sliceAmount];
}

@end

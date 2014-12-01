
#import "NSImage+GWAdditions.h"

@implementation NSImage (GWAdditions)

- (CGImageRef) CGImage {
	CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[self TIFFRepresentation],NULL);
	CGImageRef ref = CGImageSourceCreateImageAtIndex(source,0,NULL);
	CFRelease(source);
	return ref;
}

@end


#import "NSImage+Additions.h"

@implementation NSImage (Additions)

+ (NSImage *) imageWithData:(NSData *) data; {
	NSImage * image = [[NSImage alloc] initWithData:data];
	return image;
}

@end

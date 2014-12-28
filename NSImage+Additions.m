
#import "NSImage+Additions.h"

@implementation NSImage (Additions)

+ (NSImage *) imageWithData:(NSData *) data; {
	NSImage * image = [[NSImage alloc] initWithData:data];
	return image;
}

- (NSData *) PNGRepresentationWithOptions:(NSDictionary *) options; {
	CGImageRef cgimage = [self CGImageForProposedRect:nil context:nil hints:nil];
	NSBitmapImageRep * rep = [[NSBitmapImageRep alloc] initWithCGImage:cgimage];
	NSData * png = [rep representationUsingType:NSPNGFileType properties:options];
	return png;
}

- (NSData *) JPEGRepresentationWithOptions:(NSDictionary *) options; {
	CGImageRef cgimage = [self CGImageForProposedRect:nil context:nil hints:nil];
	NSBitmapImageRep * rep = [[NSBitmapImageRep alloc] initWithCGImage:cgimage];
	NSData * jpg = [rep representationUsingType:NSJPEGFileType properties:options];
	return jpg;
}

@end

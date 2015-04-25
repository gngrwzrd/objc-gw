
#import "TiledImage.h"

@implementation TiledImage

+ (TiledImage *) tileImageNamed:(NSString *) name; {
	NSString * path = [[NSBundle mainBundle] pathForImageResource:name];
	TiledImage * image = [[TiledImage alloc] initWithContentsOfFile:path];
	return image;
}

- (void) drawInRect:(NSRect) dstSpacePortionRect fromRect:(NSRect) srcSpacePortionRect
		  operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha
	 respectFlipped:(BOOL)respectContextIsFlipped hints:(NSDictionary *) hints; {
	if(!self.patternImage) {
		self.patternImage = [NSColor colorWithPatternImage:self];
	}
	[[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint(0,dstSpacePortionRect.size.height)];
	[self.patternImage setFill];
	NSRectFill(dstSpacePortionRect);
}

- (void) dealloc {
	self.patternImage = nil;
}

@end


#import "GWNinePartImage.h"

@implementation GWNinePartImage

+ (NSArray *) sliceImageForDrawNine:(NSImage *) sourceImage cornerRectSize:(NSSize) cornerRectSize {
	NSSize sourceSize = [sourceImage size];
	float doubleHeight = cornerRectSize.height * 2;
	float doubleWidth = cornerRectSize.width * 2;
	
	//top left
	NSSize topLeftSize = NSMakeSize(cornerRectSize.width,sourceSize.height-cornerRectSize.height);
	NSRect topLeftRect = NSMakeRect(0,0,topLeftSize.width,topLeftSize.height);
	NSRect topLeftCutRect = NSMakeRect(0,cornerRectSize.height,topLeftSize.width,topLeftSize.height);
	NSImage * topLeft = [[NSImage alloc] initWithSize:topLeftSize];
	[topLeft lockFocus];
	[sourceImage drawInRect:topLeftRect fromRect:topLeftCutRect operation:NSCompositeCopy fraction:1.0];
	[topLeft unlockFocus];
	
	//top
	NSSize topSize = NSMakeSize(sourceSize.width-doubleWidth,topLeftSize.height);
	NSRect topRect = NSMakeRect(0,0,topSize.width,topSize.height);
	NSRect topCutRect = NSMakeRect(cornerRectSize.width,cornerRectSize.height,topSize.width,topSize.height);
	NSImage * top = [[NSImage alloc] initWithSize:topSize];
	[top lockFocus];
	[sourceImage drawInRect:topRect fromRect:topCutRect operation:NSCompositeCopy fraction:1.0];
	[top unlockFocus];
	
	//top right
	NSSize topRightSize = NSMakeSize(sourceSize.width-cornerRectSize.width,topLeftSize.height);
	NSRect topRightRect = NSMakeRect(0,0,topRightSize.width,topRightSize.height);
	NSRect topRightCutRect = NSMakeRect(sourceSize.width-topRightSize.width,cornerRectSize.height,topRightSize.width,topRightSize.height);
	NSImage * topRight = [[NSImage alloc] initWithSize:topRightSize];
	[topRight lockFocus];
	[sourceImage drawInRect:topRightRect fromRect:topRightCutRect operation:NSCompositeSourceOver fraction:1.0];
	[topRight unlockFocus];
	
	//left
	NSSize leftSize = NSMakeSize(topLeftSize.width,sourceSize.height-doubleHeight);
	NSRect leftRect = NSMakeRect(0,0,leftSize.width,leftSize.height);
	NSRect leftCutRect = NSMakeRect(0,cornerRectSize.height,leftSize.width,leftSize.height);
	NSImage * left = [[NSImage alloc] initWithSize:leftSize];
	[left lockFocus];
	[sourceImage drawInRect:leftRect fromRect:leftCutRect operation:NSCompositeCopy fraction:1.0];
	[left unlockFocus];
	
	//center
	NSSize centerSize = NSMakeSize(topRect.size.width,leftRect.size.height);
	NSRect centerRect = NSMakeRect(0,0,centerSize.width,centerSize.height);
	NSRect centerCutRect = NSMakeRect(topCutRect.origin.x,cornerRectSize.height,centerSize.width,centerSize.height);
	NSImage * center = [[NSImage alloc] initWithSize:centerSize];
	[center lockFocus];
	[sourceImage drawInRect:centerRect fromRect:centerCutRect operation:NSCompositeCopy fraction:1.0];
	[center unlockFocus];
	
	//right
	NSSize rightSize = NSMakeSize(topRightSize.width,leftSize.height);
	NSRect rightRect = NSMakeRect(0,0,rightSize.width,rightSize.height);
	NSRect rightCutRect = NSMakeRect(cornerRectSize.width,cornerRectSize.height,rightSize.width,rightSize.height);
	NSImage * right = [[NSImage alloc] initWithSize:rightSize];
	[right lockFocus];
	[sourceImage drawInRect:rightRect fromRect:rightCutRect operation:NSCompositeCopy fraction:1.0];
	[right unlockFocus];
	
	//bottom left
	NSSize bottomLeftSize = NSMakeSize(topLeftSize.width,cornerRectSize.height);
	NSRect bottomLeftRect = NSMakeRect(0,0,bottomLeftSize.width,bottomLeftSize.height);
	NSRect bottomLeftCutRect = NSMakeRect(0,0,bottomLeftSize.width,bottomLeftSize.height);
	NSImage * bottomLeft = [[NSImage alloc] initWithSize:bottomLeftSize];
	[bottomLeft lockFocus];
	[sourceImage drawInRect:bottomLeftRect fromRect:bottomLeftCutRect operation:NSCompositeCopy fraction:1.0];
	[bottomLeft unlockFocus];
	
	//bottom
	NSSize bottomSize = NSMakeSize(topSize.width,bottomLeftSize.height);
	NSRect bottomRect = NSMakeRect(0,0,bottomSize.width,bottomSize.height);
	NSRect bottomCutRect = NSMakeRect(topCutRect.origin.x, 0, bottomSize.width, bottomSize.height);
	NSImage * bottom = [[NSImage alloc] initWithSize:bottomSize];
	[bottom lockFocus];
	[sourceImage drawInRect:bottomRect fromRect:bottomCutRect operation:NSCompositeCopy fraction:1.0];
	[bottom unlockFocus];
	
	//bottom right
	NSSize bottomRightSize = NSMakeSize(topRightSize.width,bottomLeftSize.height);
	NSRect bottomRightRect = NSMakeRect(0,0,bottomRightSize.width,bottomRightSize.height);
	NSRect bottomRightCutRect = NSMakeRect(topRightCutRect.origin.x,0,bottomRightSize.width,bottomRightSize.height);
	NSImage * bottomRight = [[NSImage alloc] initWithSize:bottomRightSize];
	[bottomRight lockFocus];
	[sourceImage drawInRect:bottomRightRect fromRect:bottomRightCutRect operation:NSCompositeCopy fraction:1.0];
	[bottomRight unlockFocus];
	NSArray * slices = [NSArray arrayWithObjects:topLeft,top,topRight,left,center,right,bottomLeft,bottom,bottomRight,nil];
	
	return slices;
}

+ (instancetype) ninePartImageNamed:(NSString *) imageName; {
	return [self ninePartImageNamed:imageName cornerSize:NSMakeSize(10,10)];
}

+ (instancetype) ninePartImageNamed:(NSString *) imageName isFlipped:(BOOL) isFlipped; {
	GWNinePartImage * img = [GWNinePartImage ninePartImageNamed:imageName];
	img.isFlipped = isFlipped;
	return img;
}

+ (instancetype) ninePartImageNamed:(NSString *) imageName cornerSize:(NSSize) cornerSize; {
	NSImage * sourceImage = [NSImage imageNamed:imageName];
	GWNinePartImage * resizableImage = [[GWNinePartImage alloc] initWithSize:sourceImage.size];
	resizableImage.slices = [GWNinePartImage sliceImageForDrawNine:sourceImage cornerRectSize:cornerSize];
	return resizableImage;
}

+ (instancetype) ninePartImageNamed:(NSString *) imageName cornerSize:(NSSize) cornerSize isFlipped:(BOOL) isFlipped; {
	GWNinePartImage * img = [GWNinePartImage ninePartImageNamed:imageName cornerSize:cornerSize];
	img.isFlipped = isFlipped;
	return img;
}

+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage; {
	return [self ninePartImageFromSourceImage:sourceImage cornerSize:NSMakeSize(10,10)];
}

+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage isFlipped:(BOOL) isFlipped; {
	GWNinePartImage * img = [GWNinePartImage ninePartImageFromSourceImage:sourceImage];
	img.isFlipped = isFlipped;
	return img;
}

+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage cornerSize:(NSSize) cornerSize; {
	GWNinePartImage * resizableImage = [[GWNinePartImage alloc] initWithSize:sourceImage.size];
	resizableImage.slices = [GWNinePartImage sliceImageForDrawNine:sourceImage cornerRectSize:cornerSize];
	return resizableImage;
}

+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage cornerSize:(NSSize) cornerSize isFlipped:(BOOL) isFlipped; {
	GWNinePartImage * img = [GWNinePartImage ninePartImageFromSourceImage:sourceImage cornerSize:cornerSize];
	img.isFlipped = isFlipped;
	return img;
}

- (BOOL) isFlipped {
	return _isFlipped;
}

- (void) setIsFlipped:(BOOL)isFlipped {
	_isFlipped = isFlipped;
}

- (void) drawInRect:(NSRect) dstSpacePortionRect fromRect:(NSRect) srcSpacePortionRect
		  operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha
	 respectFlipped:(BOOL)respectContextIsFlipped hints:(NSDictionary *) hints;
{
	if(!self.slices || self.slices.count < 9) {
		NSLog(@"error with slices for nine part image.");
		return;
	}
	NSDrawNinePartImage(dstSpacePortionRect,self.slices[0],self.slices[1],
		self.slices[2],self.slices[3],self.slices[4],self.slices[5],
		self.slices[6],self.slices[7],self.slices[8],op,requestedAlpha,respectContextIsFlipped);
}

- (void) dealloc {
	self.slices = nil;
}

@end

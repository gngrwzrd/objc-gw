
#import "ThreePartImage.h"

@interface ThreePartImage ()
@property NSArray * slices;
@property BOOL isVertical;
@end

@implementation ThreePartImage

+ (NSArray *) sliceImageForDrawThree:(NSImage *) sourceImage sliceSize:(NSSize) sliceSize vertical:(BOOL) vertical flipped:(BOOL) flipped {
	NSSize sourceSize = [sourceImage size];
	float doubleHeight = sliceSize.height * 2;
	float doubleWidth = sliceSize.width * 2;
	NSArray * slices = NULL;
	if(vertical) {
		//top
		NSSize topSize = NSMakeSize(sourceSize.width,sliceSize.height);
		NSRect topRect = NSMakeRect(0,0,topSize.width,topSize.height);
		NSRect topCutRect = NSMakeRect(0,sourceSize.height-sliceSize.height,topSize.width,topSize.height);
		NSImage * top = [NSImage imageWithSize:topSize flipped:false drawingHandler:^BOOL(NSRect dstRect) {
			[sourceImage drawInRect:topRect fromRect:topCutRect operation:NSCompositeCopy fraction:1];
			return TRUE;
		}];
		
		//middle
		NSSize middleSize = NSMakeSize(sourceSize.width,sourceSize.height-doubleHeight);
		NSRect middleRect = NSMakeRect(0,0,middleSize.width,middleSize.height);
		NSRect middleCutRect = NSMakeRect(0,topSize.height,middleSize.width,middleSize.height);
		NSImage * middle = [NSImage imageWithSize:middleSize flipped:false drawingHandler:^BOOL(NSRect dstRect) {
			[sourceImage drawInRect:middleRect fromRect:middleCutRect operation:NSCompositeCopy fraction:1];
			return TRUE;
		}];
		
		//bottom
		NSSize bottomSize = NSMakeSize(sourceSize.width,sliceSize.height);
		NSRect bottomRect = NSMakeRect(0,0,bottomSize.width,bottomSize.height);
		NSRect bottomCutRect = NSMakeRect(0,0,bottomSize.width,bottomSize.height);
		NSImage * bottom = [NSImage imageWithSize:bottomSize flipped:false drawingHandler:^BOOL(NSRect dstRect) {
			[sourceImage drawInRect:bottomRect fromRect:bottomCutRect operation:NSCompositeCopy fraction:1];
			return TRUE;
		}];
		
		slices = [NSArray arrayWithObjects:top,middle,bottom,nil];
		
	} else {
		//left
		NSSize leftSize = NSMakeSize(sliceSize.width,sourceSize.height);
		NSRect leftRect = NSMakeRect(0,0,leftSize.width,leftSize.height);
		NSRect leftCutRect = NSMakeRect(0,0,leftSize.width,leftSize.height);
		NSImage * left = [NSImage imageWithSize:leftSize flipped:false drawingHandler:^BOOL(NSRect dstRect) {
			[sourceImage drawInRect:leftRect fromRect:leftCutRect operation:NSCompositeCopy fraction:1];
			return TRUE;
		}];
		
		//center
		NSSize centerSize = NSMakeSize(sourceSize.width-doubleWidth,sourceSize.height);
		NSRect centerRect = NSMakeRect(0,0,centerSize.width,centerSize.height);
		NSRect centerCutRect = NSMakeRect(leftSize.width,0,centerSize.width,centerSize.height);
		NSImage * center = [NSImage imageWithSize:centerSize flipped:false drawingHandler:^BOOL(NSRect dstRect) {
			[sourceImage drawInRect:centerRect fromRect:centerCutRect operation:NSCompositeCopy fraction:1];
			return TRUE;
		}];
		
		//right
		NSSize rightSize = NSMakeSize(sliceSize.width,sourceSize.height);
		NSRect rightRect = NSMakeRect(0,0,rightSize.width,rightSize.height);
		NSRect rightCutRect = NSMakeRect(leftSize.width+centerSize.width,0,rightSize.width,rightSize.height);
		NSImage * right = [NSImage imageWithSize:rightSize flipped:false drawingHandler:^BOOL(NSRect dstRect) {
			[sourceImage drawInRect:rightRect fromRect:rightCutRect operation:NSCompositeCopy fraction:1];
			return TRUE;
		}];
		
		slices = [NSArray arrayWithObjects:left,center,right,nil];
	}
	
	return slices;
}

+ (instancetype) threePartVerticalImageNamed:(NSString *) imageName sliceAmount:(CGFloat) sliceAmount {
	NSImage * sourceImage = [NSImage imageNamed:imageName];
	ThreePartImage * image = [[ThreePartImage alloc] initWithSize:sourceImage.size];
	image.slices = [self sliceImageForDrawThree:sourceImage sliceSize:NSMakeSize(0,sliceAmount) vertical:true flipped:false];
	image.isVertical = TRUE;
	return image;
}

+ (instancetype) threePartHorizontalImageNamed:(NSString *) imageName sliceAmount:(CGFloat) sliceAmount {
	NSImage * sourceImage = [NSImage imageNamed:imageName];
	ThreePartImage * image = [[ThreePartImage alloc] initWithSize:sourceImage.size];
	image.slices = [self sliceImageForDrawThree:sourceImage sliceSize:NSMakeSize(sliceAmount,0) vertical:false flipped:false];
	image.isVertical = FALSE;
	return image;
}

- (void) drawInRect:(NSRect) dstSpacePortionRect fromRect:(NSRect) srcSpacePortionRect
		  operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha
	 respectFlipped:(BOOL)respectContextIsFlipped hints:(NSDictionary *) hints;
{
	if(!self.slices || self.slices.count < 3) {
		NSLog(@"ThreePartImage is not set. Cannot draw anything.");
		return;
	}
	BOOL flipped = false;
	if(respectContextIsFlipped) {
		flipped = [[NSGraphicsContext currentContext] isFlipped];
	}
	NSDrawThreePartImage(dstSpacePortionRect,self.slices[0],self.slices[1],self.slices[2],self.isVertical,op,requestedAlpha,flipped);
}

- (void) dealloc {
	self.slices = nil;
}

@end

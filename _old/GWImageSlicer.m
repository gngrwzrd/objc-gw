
#import "GWImageSlicer.h"

@implementation GWImageSlicer

+ (NSArray *) sliceImageForDrawThree:(NSImage *) sourceImage sliceSize:(NSSize) sliceSize vertical:(BOOL) vertical flipped:(BOOL) flipped {
	NSSize sourceSize = [sourceImage size];
	float doubleHeight = sliceSize.height * 2;
	float doubleWidth = sliceSize.width * 2;
	NSArray * slices = NULL;
	if(vertical) {
		//top
		NSSize topSize = NSMakeSize(sourceSize.width,sliceSize.height);
		NSRect topRect = NSMakeRect(0,0,topSize.width,topSize.height);
		NSRect topCutRect;
		if(flipped) topCutRect = NSMakeRect(0,0,topSize.width,topSize.height);
		else topCutRect = NSMakeRect(0,sourceSize.height-sliceSize.height,topSize.width,topSize.height);
		NSImage * top = [[NSImage alloc] initWithSize:topSize];
		[top lockFocus];
		[sourceImage drawInRect:topRect fromRect:topCutRect operation:NSCompositeCopy fraction:1];
		[top unlockFocus];
		
		//middle
		NSSize middleSize = NSMakeSize(sourceSize.width,sourceSize.height-doubleHeight);
		NSRect middleRect = NSMakeRect(0,0,middleSize.width,middleSize.height);
		NSRect middleCutRect = NSMakeRect(0,topSize.height,middleSize.width,middleSize.height);
		NSImage * middle = [[NSImage alloc] initWithSize:middleSize];
		[middle lockFocus];
		[sourceImage drawInRect:middleRect fromRect:middleCutRect operation:NSCompositeCopy fraction:1];
		[middle unlockFocus];
		
		//bottom
		NSSize bottomSize = NSMakeSize(sourceSize.width,sliceSize.height);
		NSRect bottomRect = NSMakeRect(0,0,bottomSize.width,bottomSize.height);
		NSRect bottomCutRect;
		if(flipped) bottomCutRect = NSMakeRect(0,topSize.height+middleSize.height,bottomSize.width,bottomSize.height);
		else bottomCutRect = NSMakeRect(0,0,bottomSize.width,bottomSize.height);
		NSImage * bottom = [[NSImage alloc] initWithSize:bottomSize];
		[bottom lockFocus];
		[sourceImage drawInRect:bottomRect fromRect:bottomCutRect operation:NSCompositeCopy fraction:1];
		[bottom unlockFocus];
		//assemble
		slices = [NSArray arrayWithObjects:top,middle,bottom,nil];
		return slices;
	} else {
		//left
		NSSize leftSize = NSMakeSize(sliceSize.width,sourceSize.height);
		NSRect leftRect = NSMakeRect(0,0,leftSize.width,leftSize.height);
		NSRect leftCutRect = NSMakeRect(0,0,leftSize.width,leftSize.height);
		NSImage * left = [[NSImage alloc] initWithSize:leftSize];
		[left lockFocus];
		[sourceImage drawInRect:leftRect fromRect:leftCutRect operation:NSCompositeCopy fraction:1];
		[left unlockFocus];
		
		//center
		NSSize centerSize = NSMakeSize(sourceSize.width-doubleWidth,sourceSize.height);
		NSRect centerRect = NSMakeRect(0,0,centerSize.width,centerSize.height);
		NSRect centerCutRect = NSMakeRect(leftSize.width,0,centerSize.width,centerSize.height);
		NSImage * center = [[NSImage alloc] initWithSize:centerSize];
		[center lockFocus];
		[sourceImage drawInRect:centerRect fromRect:centerCutRect operation:NSCompositeCopy fraction:1];
		[center unlockFocus];
		
		//right
		NSSize rightSize = NSMakeSize(sliceSize.width,sourceSize.height);
		NSRect rightRect = NSMakeRect(0,0,rightSize.width,rightSize.height);
		NSRect rightCutRect = NSMakeRect(leftSize.width+centerSize.width,0,rightSize.width,rightSize.height);
		NSImage * right = [[NSImage alloc] initWithSize:rightSize];
		[right lockFocus];
		[sourceImage drawInRect:rightRect fromRect:rightCutRect operation:NSCompositeCopy fraction:1];
		[right unlockFocus];
		slices = [NSArray arrayWithObjects:left,center,right,nil];
	}
	return slices;
}

@end

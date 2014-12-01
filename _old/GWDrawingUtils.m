
#import "GWDrawingUtils.h"

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

NSArray * sliceImageForDrawThree(NSImage * sourceImage, NSSize sliceSize, Boolean vertical, Boolean flipped) {
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
		[top autorelease];
		[middle autorelease];
		[bottom	 autorelease];
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
		[left autorelease];
		[center autorelease];
		[right autorelease];
	}
	return slices;
}

NSArray * sliceImageForDrawNine(NSImage * sourceImage, NSSize cornerRectSize) {
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
	[topLeft release];
	[top release];
	[topRight release];
	[left release];
	[center release];
	[right release];
	[bottomLeft release];
	[bottom release];
	[bottomRight release];
	return slices;
}

#endif
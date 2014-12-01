//copyright 2009 aaronsmith

#import "QuartzDisplay.h"

@implementation QuartzDisplay
@synthesize displayId;

+ (NSMutableArray *) activeDisplays {
	NSMutableArray * res = [NSMutableArray array];
	CGDirectDisplayID ids[kMaxDisplays];
	CGDisplayCount count;
	CGDisplayErr e = CGGetActiveDisplayList(kMaxDisplays,ids,&count);
	if(e > 0) return nil;
	int i = 0;
	for(i=0;i < count; i++) {
		QuartzDisplay * dis = [[[QuartzDisplay alloc] initWithDirectDisplayID:(CGDirectDisplayID)ids[i]] autorelease];
		if(dis != nil) [res addObject:dis];
	}
	return res;
}

+ (NSMutableArray *) onlineDisplays {
	NSMutableArray * res = [NSMutableArray array];
	CGDirectDisplayID ids[kMaxDisplays];
	CGDisplayCount count;
	CGDisplayErr e = CGGetOnlineDisplayList(kMaxDisplays,ids,&count);
	if(e > 0) return nil;
	int i = 0;
	for(i=0;i < count; i++) {
		QuartzDisplay * dis = [[[QuartzDisplay alloc] initWithDirectDisplayID:(CGDirectDisplayID)ids[i]] autorelease];
		if(dis != nil) [res addObject:dis];
	}
	return res;
}

+ (QuartzDisplay *) mainDisplay {
	return [[[QuartzDisplay alloc] initWithDirectDisplayID:CGMainDisplayID()] autorelease];
}

- (id) initWithPoint:(NSPoint) point {
	if(!(self = [super init])) return nil;
	CGPoint tp;
	tp.x = point.x;
	tp.y = point.y;
	CGDirectDisplayID ids[kMaxDisplays];
	CGDisplayCount count;
	CGDisplayErr e = CGGetDisplaysWithPoint(tp,kMaxDisplays,ids,&count);
	if(e > 0) return nil;
	if(count < 1) return nil;
	if(count == 1) {
		displayId = (CGDirectDisplayID) ids[0];
	} else {
		CGDirectDisplayID tmp = (CGDirectDisplayID) ids[0];
		displayId = CGDisplayPrimaryDisplay(tmp);
	}
	return self;
}

- (id) initWithRect:(NSRect) rect {
	if(!(self = [super init])) return nil;
	CGRect tr;
	tr.origin.x = rect.origin.x;
	tr.origin.y = rect.origin.y;
	tr.size.width = rect.size.width;
	tr.size.height = rect.size.height;
	CGDirectDisplayID ids[kMaxDisplays];
	CGDisplayCount count;
	CGDisplayErr e = CGGetDisplaysWithRect(tr,kMaxDisplays,ids,&count);
	if(e > 0) return nil;
	if(count < 1) return nil;
	if(count == 1) {
		displayId = (CGDirectDisplayID) ids[0];
	} else {
		CGDirectDisplayID tmp = (CGDirectDisplayID) ids[0];
		displayId = CGDisplayPrimaryDisplay(tmp);
	}
	return self;
}

- (id) initWithDirectDisplayID:(CGDirectDisplayID) ddid {
	if(!(self = [super init])) return nil;
	displayId = ddid;
	return self;
}

- (Boolean) isMainDisplay {
	return (Boolean) CGDisplayIsMain(displayId);
}

- (Boolean) isActive {
	return (Boolean) CGDisplayIsActive(displayId);
}

- (Boolean) isAlwaysInMirrorSet {
	return (Boolean) CGDisplayIsAlwaysInMirrorSet(displayId);
}

- (Boolean) isSleeping {
	return (Boolean) CGDisplayIsAsleep(displayId);
}

- (Boolean) isInMirrorSet {
	return (Boolean) CGDisplayIsInMirrorSet(displayId);
}

- (Boolean) isOnline {
	return (Boolean) CGDisplayIsOnline(displayId);
}

- (Boolean) isStereo {
	return (Boolean) CGDisplayIsStereo(displayId);
}

- (Boolean) isPrimaryDisplayInMirrorSet {
	return FALSE;
}

- (QuartzDisplay *) mirrorsDisplay {
	CGDirectDisplayID mirroredDisplayID = CGDisplayMirrorsDisplay(displayId);
	if(mirroredDisplayID == kCGNullDirectDisplay) return nil;
	return [[[QuartzDisplay alloc] initWithDirectDisplayID:mirroredDisplayID] autorelease];
}

- (QuartzDisplay *) primaryDisplay {
	CGDirectDisplayID primaryDisplayID = CGDisplayPrimaryDisplay(displayId);
	if(primaryDisplayID == kCGNullDirectDisplay) return nil;
	return [[[QuartzDisplay alloc] initWithDirectDisplayID:primaryDisplayID] autorelease];
}

- (double) rotation {
	return CGDisplayRotation(displayId);
}

- (NSSize) millimeterSize {
	CGSize s = CGDisplayScreenSize(displayId);
	return NSMakeSize(s.width,s.height);
}

- (NSSize) pixelSize {
	CGFloat w = (CGFloat)CGDisplayPixelsWide(displayId);
	CGFloat h = (CGFloat)CGDisplayPixelsHigh(displayId);
	return NSMakeSize(w,h);
}

- (NSRect) bounds {
	CGRect bnds = CGDisplayBounds(displayId);
	return NSMakeRect(bnds.origin.x,bnds.origin.y,bnds.size.width,bnds.size.height);
}

- (NSScreen *) screen {
	NSArray * screens = [NSScreen screens];
	NSScreen * sc = nil;
	for(sc in [screens objectEnumerator]) {
		NSDictionary * dvd = [sc deviceDescription];
		NSNumber * scrID = [dvd valueForKey:@"NSScreenNumber"];
		CGDirectDisplayID did = (CGDirectDisplayID)[scrID unsignedIntValue];
		if(did == displayId) return sc;
	}
	return sc;
}

- (Boolean) usesOpenGLAcceleration {
	return CGDisplayUsesOpenGLAcceleration(displayId);
}

- (void) dealloc {
	displayId = 0;
	[super dealloc];
}

@end

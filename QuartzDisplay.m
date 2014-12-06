
#import "QuartzDisplay.h"

#define kMaxDisplays 48

@implementation QuartzDisplay

+ (NSUInteger) numberOfDisplays {
	CGDirectDisplayID displays[kMaxDisplays];
	uint32_t displayCount = kMaxDisplays;
	CGGetActiveDisplayList(kMaxDisplays,displays,&displayCount);
	return displayCount;
}

+ (NSArray *) displays {
	NSMutableArray * quartzDisplays = [NSMutableArray array];
	CGDirectDisplayID displays[kMaxDisplays];
	uint32_t displayCount = kMaxDisplays;
	CGGetActiveDisplayList(kMaxDisplays,displays,&displayCount);
	for(NSUInteger i = 0; i<kMaxDisplays; i++) {
		QuartzDisplay * display = [[QuartzDisplay alloc] initWithCGDirectDisplayId:displays[i]];
		[quartzDisplays addObject:display];
	}
	return quartzDisplays;
}

- (id) initWithCGDirectDisplayId:(CGDirectDisplayID) directDisplayId {
	self = [super init];
	self.displayId = directDisplayId;
	return self;
}

- (id) initWithPoint:(NSPoint) point; {
	self = [super init];
	CGPoint tp;
	tp.x = point.x;
	tp.y = point.y;
	CGDirectDisplayID ids[kMaxDisplays];
	CGDisplayCount count;
	CGDisplayErr e = CGGetDisplaysWithPoint(tp,kMaxDisplays,ids,&count);
	if(e > 0) return nil;
	if(count < 1) return nil;
	if(count == 1) {
		self.displayId = (CGDirectDisplayID)ids[0];
	} else {
		CGDirectDisplayID tmp = (CGDirectDisplayID) ids[0];
		self.displayId = CGDisplayPrimaryDisplay(tmp);
	}
	return self;
}

- (id) initWithRect:(NSRect) rect; {
	self = [super init];
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
		self.displayId = (CGDirectDisplayID) ids[0];
	} else {
		CGDirectDisplayID tmp = (CGDirectDisplayID) ids[0];
		self.displayId = CGDisplayPrimaryDisplay(tmp);
	}
	return self;
}

- (NSSize) pixelSize {
	CGFloat w = (CGFloat)CGDisplayPixelsWide(self.displayId);
	CGFloat h = (CGFloat)CGDisplayPixelsHigh(self.displayId);
	return NSMakeSize(w,h);
}

- (NSRect) bounds {
	return CGDisplayBounds(self.displayId);
}

- (NSScreen *) screen {
	NSArray * screens = [NSScreen screens];
	NSScreen * sc = nil;
	for(sc in [screens objectEnumerator]) {
		NSDictionary * dvd = [sc deviceDescription];
		NSNumber * scrID = [dvd valueForKey:@"NSScreenNumber"];
		CGDirectDisplayID did = (CGDirectDisplayID)[scrID unsignedIntValue];
		if(did == self.displayId) {
			return sc;
		}
	}
	return sc;
}

- (NSString *) serialNumber; {
	uint32_t serial = CGDisplaySerialNumber(self.displayId);
	return [NSString stringWithFormat:@"%u",serial];
}

- (NSString *) vendorNumber {
	uint32_t vendor = CGDisplayVendorNumber(self.displayId);
	return [NSString stringWithFormat:@"%u",vendor];
}

- (NSString *) unitNumber {
	uint32_t unit = CGDisplayUnitNumber(self.displayId);
	return [NSString stringWithFormat:@"%u",unit];
}

- (NSString *) serialAndVendorAndUnit {
	return [NSString stringWithFormat:@"%@_%@_%@",self.serialNumber,self.vendorNumber,self.unitNumber];
}

- (BOOL) isEqualToDisplay:(QuartzDisplay *) display; {
	return self.displayId == display.displayId;
}

- (NSString *) description {
	NSSize pixels = [self pixelSize];
	return [NSString stringWithFormat:@"<QuartzDisplay:%p> (displayId:%u, width:%fpx, height:%fpx)",self,self.displayId,pixels.width,pixels.height];
}

@end

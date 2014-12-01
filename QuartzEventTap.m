
#import "QuartzEventTap.h"

@interface QuartzEventTap ()
@property CFMachPortRef eventTap;
@property CFRunLoopSourceRef runloopSource;
@end

CGEventRef QuartzEventTapCallbackFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void * refcon) {
	QuartzEventTap * quartzTapper = (__bridge QuartzEventTap *)refcon;
	quartzTapper.callback(proxy,type,event,quartzTapper);
	return event;
}

@implementation QuartzEventTap

- (id) init {
	self = [super init];
	self.eventTapLocation = kCGHIDEventTap;
	self.eventTapPlacement = kCGHeadInsertEventTap;
	return self;
}

- (void) start; {
	if(!self.eventTap) {
		self.eventTap = CGEventTapCreate(
			self.eventTapLocation,self.eventTapPlacement,
			self.eventTapOptions,self.eventTapEvents,
			QuartzEventTapCallbackFunction,(__bridge void *)(self)
		);
	}
	CGEventTapEnable(self.eventTap,true);
	if(!self.runloopSource) {
		self.runloopSource = CFMachPortCreateRunLoopSource(NULL,self.eventTap,0);
	}
	CFRunLoopAddSource(CFRunLoopGetMain(),self.runloopSource,kCFRunLoopDefaultMode);
	self.isRunning = TRUE;
}

- (void) stop; {
	CGEventTapEnable(self.eventTap,false);
	CFRunLoopRemoveSource(CFRunLoopGetMain(),self.runloopSource,kCFRunLoopDefaultMode);
	self.isRunning = FALSE;
}

@end

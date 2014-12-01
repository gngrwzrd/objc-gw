
#import "QuartzKeyEventManager.h"

static QuartzKeyEventManager * __sharedInstance;

@interface QuartzKeyEventManager ()
@property NSMutableArray * keyEvents;
@property CFMachPortRef eventTap;
@property CFRunLoopSourceRef runloopSource;
- (CGEventRef) recievedEvent:(CGEventRef) event;
@end

CGEventRef QuartzEventTapManagerCallbackFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void * refcon) {
	return [[QuartzKeyEventManager sharedManager] recievedEvent:event];
}

@implementation QuartzKeyEventManager

+ (QuartzKeyEventManager *) sharedManager {
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		__sharedInstance = [[QuartzKeyEventManager alloc] init];
	});
	return __sharedInstance;
}

- (id) init {
	self = [super init];
	self.keyEvents = [NSMutableArray array];
	[self startEventTap];
	return self;
}

- (void) startEventTap {
	if(!self.eventTap) {
		self.eventTap = CGEventTapCreate(
			kCGHIDEventTap,kCGHeadInsertEventTap,kCGEventTapOptionListenOnly,
			CGEventMaskBit(kCGEventKeyUp)|CGEventMaskBit(kCGEventFlagsChanged),
			QuartzEventTapManagerCallbackFunction,(__bridge void *)(self)
		);
	}
	CGEventTapEnable(self.eventTap,true);
	if(!self.runloopSource) {
		self.runloopSource = CFMachPortCreateRunLoopSource(NULL,self.eventTap,0);
	}
	CFRunLoopAddSource(CFRunLoopGetMain(),self.runloopSource,kCFRunLoopDefaultMode);
}

- (void) stopEventTap {
	CGEventTapEnable(self.eventTap,false);
	CFRunLoopRemoveSource(CFRunLoopGetMain(),self.runloopSource,kCFRunLoopDefaultMode);
}

- (void) restoreTargetActions:(QuartzEventManagerRestoreTargetAction) callback {
	for(QuartzKeyEvent * keyEvent in self.keyEvents) {
		callback(keyEvent);
	}
}

- (CGEventRef) recievedEvent:(CGEventRef) event {
	CGEventFlags flags = CGEventGetFlags(event);
	int64_t intValue = CGEventGetIntegerValueField(event,kCGKeyboardEventKeycode);
	NSEventModifierFlags cocoaFlags = 0;
	
	if(flags & NX_COMMANDMASK) {
		cocoaFlags |= NSCommandKeyMask;
	}
	
	if(flags & NX_ALTERNATEMASK) {
		cocoaFlags |= NSAlternateKeyMask;
	}
	
	if(flags & NX_CONTROLMASK) {
		cocoaFlags |= NSControlKeyMask;
	}
	
	if(flags & NX_SHIFTMASK) {
		cocoaFlags |= NSShiftKeyMask;
	}
	
	for(QuartzKeyEvent * keyEvent in self.keyEvents) {
		NSLog(@"keyEvent.keyCode: %lu, keyEvent.modifiers: %lu, cocoaModifiers: %lu",keyEvent.keyCode,keyEvent.modifiers,cocoaFlags);
		if(keyEvent.keyCode == intValue && keyEvent.modifiers == cocoaFlags) {
			[keyEvent.target performSelectorOnMainThread:keyEvent.action withObject:keyEvent waitUntilDone:FALSE];
		}
	}
	
	return event;
}

- (void) addQuartzKeyEvent:(QuartzKeyEvent *) event {
	if(![self hasKeyEvent:event]) {
		[self.keyEvents addObject:event];
	}
}

- (void) removeQuartzKeyEvent:(QuartzKeyEvent *) event {
	NSMutableArray * remove = [NSMutableArray array];
	for(QuartzKeyEvent * keyEvent in self.keyEvents) {
		if(keyEvent.keyCode == event.keyCode && keyEvent.modifiers == event.modifiers) {
			[remove addObject:keyEvent];
		}
	}
	if(remove.count > 0) {
		[self.keyEvents removeObjectsInArray:remove];
	}
}

- (void) removeQuartzKeyEventForKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers {
	NSMutableArray * remove = [NSMutableArray array];
	for(QuartzKeyEvent * keyEvent in self.keyEvents) {
		if(keyEvent.keyCode == keyCode && keyEvent.modifiers == modifiers) {
			[remove addObject:keyEvent];
		}
	}
	if(remove.count > 0) {
		[self.keyEvents removeObjectsInArray:remove];
	}
}

- (BOOL) hasKeyEvent:(QuartzKeyEvent *) event {
	for(QuartzKeyEvent * keyEvent in self.keyEvents) {
		if(keyEvent.keyCode == event.keyCode && keyEvent.modifiers == event.modifiers) {
			return TRUE;
		}
	}
	return FALSE;
}

- (BOOL) hasKeyEventForKeyCode:(NSUInteger)keyCode modifiers:(NSEventModifierFlags)modifiers {
	for(QuartzKeyEvent * keyEvent in self.keyEvents) {
		if(keyEvent.keyCode == keyCode && keyEvent.modifiers == modifiers) {
			return TRUE;
		}
	}
	return FALSE;
}

@end

@implementation QuartzKeyEvent
+ (instancetype) eventWithKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers; {
	QuartzKeyEvent * event = [[QuartzKeyEvent alloc] init];
	event.keyCode = keyCode;
	event.modifiers = modifiers;
	return event;
}
@end

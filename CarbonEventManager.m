
#import "CarbonEventManager.h"

NSString * const CarbonEventManagerKeyEventsDefaultsKey = @"CarbonEventManagerKeyEvents";

@interface CarbonKeyEvent () {
@public
	EventHandlerRef _eventHandlerRef;
	EventHotKeyRef _hotKeyRef;
	EventHotKeyID _hotKeyId;
	EventTypeSpec _eventSpec;
}
@end

@interface CarbonEventManager ()
@property NSMutableDictionary * keyEvents;
- (NSNumber *) hotKeyIdFromKeyEvent:(CarbonKeyEvent *) keyEvent;
- (CarbonKeyEvent *) keyEventFromHotKeyId:(unsigned int) hotKeyId;
@end

static unsigned int __eventId = 1;
static CarbonEventManager * __sharedManager;

static OSStatus carbonEventHotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void * userData) {
	EventHotKeyID hkRef;
	OSStatus res = GetEventParameter(anEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,sizeof(hkRef),NULL,&hkRef);
	if(res) {
		return res;
	}
	CarbonKeyEvent * keyEvent = [[CarbonEventManager sharedManager] keyEventFromHotKeyId:hkRef.id];
	[keyEvent invoke];
	return noErr;
}

@implementation CarbonEventManager

+ (NSUInteger) carbonToCocoaModifierFlags:(NSUInteger) carbonFlags {
	NSUInteger cocoaFlags = 0;
	if(carbonFlags & cmdKey) cocoaFlags |= NSCommandKeyMask;
	if(carbonFlags & optionKey) cocoaFlags |= NSAlternateKeyMask;
	if(carbonFlags & controlKey) cocoaFlags |= NSControlKeyMask;
	if(carbonFlags & shiftKey) cocoaFlags |= NSShiftKeyMask;
	if(carbonFlags & NSFunctionKeyMask) cocoaFlags += NSFunctionKeyMask;
	return cocoaFlags;
}

+ (NSUInteger) cocoaToCarbonModifierFlags:(NSUInteger) cocoaFlags {
	NSUInteger carbonFlags = 0;
	if(cocoaFlags & NSCommandKeyMask) carbonFlags |= cmdKey;
	if(cocoaFlags & NSAlternateKeyMask) carbonFlags |= optionKey;
	if(cocoaFlags & NSControlKeyMask) carbonFlags |= controlKey;
	if(cocoaFlags & NSShiftKeyMask) carbonFlags |= shiftKey;
	if(cocoaFlags & NSFunctionKeyMask) carbonFlags |= NSFunctionKeyMask;
	return carbonFlags;
}

+ (CarbonEventManager *) sharedManager; {
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		__sharedManager = [[CarbonEventManager alloc] init];
	});
	return __sharedManager;
}

- (id) init {
	self = [super init];
	self.keyEvents = [NSMutableDictionary dictionary];
	[self restoreFromDefaults];
	return self;
}

- (NSNumber *) keyForKeyCode:(NSUInteger) keyCode modifierFlags:(NSEventModifierFlags) modifierFlags {
	return [NSNumber numberWithUnsignedInteger:keyCode+modifierFlags];
}

- (NSNumber *) hotKeyIdFromKeyEvent:(CarbonKeyEvent *) keyEvent {
	return [NSNumber numberWithUnsignedInt:keyEvent->_hotKeyId.id];
}

- (CarbonKeyEvent *) keyEventFromHotKeyId:(unsigned int) hotKeyId; {
	NSNumber * key = @(hotKeyId);
	return self.keyEvents[key];
}

- (void) saveToDefaults {
	if(!self.writesToDefaults) {
		return;
	}
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSData * keyEvents = [NSKeyedArchiver archivedDataWithRootObject:self.keyEvents];
	[defaults setObject:keyEvents forKey:CarbonEventManagerKeyEventsDefaultsKey];
}

- (void) restoreFromDefaults {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSData * keyEventsData = [defaults objectForKey:CarbonEventManagerKeyEventsDefaultsKey];
	[self restoreKeyEventsFromData:keyEventsData];
}

- (NSData *) keyEventsData {
	NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.keyEvents];
	return data;
}

- (void) restoreKeyEventsFromData:(NSData *) keyEventsData; {
	if(keyEventsData) {
		NSDictionary * originalKeyEvents = [NSKeyedUnarchiver unarchiveObjectWithData:keyEventsData];
		NSMutableDictionary * keyEventsToAdd = [NSMutableDictionary dictionaryWithDictionary:originalKeyEvents];
		if(keyEventsToAdd) {
			for(NSNumber * key in keyEventsToAdd) {
				CarbonKeyEvent * keyEvent = keyEventsToAdd[key];
				[self addCarbonKeyEvent:keyEvent];
			}
		}
	}
}

- (void) restoreTargetActions:(CarbonEventManagerRestoreTargetAction) restoreHandler; {
	for(NSString * key in self.keyEvents) {
		CarbonKeyEvent * keyEvent = self.keyEvents[key];
		restoreHandler(keyEvent);
	}
}

- (NSArray *) allKeyEvents; {
	NSMutableArray * keyEvents = [NSMutableArray array];
	for(NSNumber * key in self.keyEvents) {
		CarbonKeyEvent * keyEvent = self.keyEvents[key];
		if(![keyEvents containsObject:keyEvents]) {
			[keyEvents addObject:keyEvent];
		}
	}
	return keyEvents;
}

- (void) addCarbonKeyEvent:(CarbonKeyEvent *) keyEvent; {
	NSNumber * key = [self keyForKeyCode:keyEvent.keyCode modifierFlags:keyEvent.modifierFlags];
	if(self.keyEvents[key]) {
		[self removeCarbonKeyEvent:self.keyEvents[key]];
	}
	
	NSUInteger keyCode = keyEvent.keyCode;
	NSUInteger modifiers = [CarbonEventManager cocoaToCarbonModifierFlags:keyEvent.modifierFlags];
	
	if(__eventId == UINT32_MAX) {
		__eventId = 0;
	}
	
	keyEvent->_hotKeyId.id = (UInt32)__eventId++;
	keyEvent->_eventSpec.eventClass = kEventClassKeyboard;
	keyEvent->_eventSpec.eventKind = kEventHotKeyPressed;
	
	RegisterEventHotKey((UInt32)keyCode,(UInt32)modifiers,keyEvent->_hotKeyId,GetApplicationEventTarget(),0,&(keyEvent->_hotKeyRef));
	InstallApplicationEventHandler(&carbonEventHotKeyHandler,1,&(keyEvent->_eventSpec),NULL,&(keyEvent->_eventHandlerRef));
	
	self.keyEvents[key] = keyEvent;
	self.keyEvents[[self hotKeyIdFromKeyEvent:keyEvent]] = keyEvent;
	[self saveToDefaults];
}

- (void) addCarbonKeyEventsInArray:(NSArray *) array; {
	for(CarbonKeyEvent * carbonKeyEvent in array) {
		[self addCarbonKeyEvent:carbonKeyEvent];
	}
}

- (void) removeCarbonKeyEvent:(CarbonKeyEvent *) keyEvent; {
	NSNumber * key = [self keyForKeyCode:keyEvent.keyCode modifierFlags:keyEvent.modifierFlags];
	if(self.keyEvents[key]) {
		RemoveEventHandler(keyEvent->_eventHandlerRef);
		UnregisterEventHotKey(keyEvent->_hotKeyRef);
		[self.keyEvents removeObjectForKey:key];
		[self.keyEvents removeObjectForKey:[self hotKeyIdFromKeyEvent:keyEvent]];
	}
	[self saveToDefaults];
}

- (void) removeCarbonKeyEventWithKeyCode:(NSUInteger) keyCode modifierFlags:(NSUInteger) modifierFlags; {
	NSNumber * key = [self keyForKeyCode:keyCode modifierFlags:modifierFlags];
	if(self.keyEvents[key]) {
		CarbonKeyEvent * keyEvent = self.keyEvents[key];
		RemoveEventHandler(keyEvent->_eventHandlerRef);
		UnregisterEventHotKey(keyEvent->_hotKeyRef);
		[self.keyEvents removeObjectForKey:key];
		[self.keyEvents removeObjectForKey:[self hotKeyIdFromKeyEvent:keyEvent]];
	}
	[self saveToDefaults];
}

- (BOOL) hasCarbonKeyEvent:(CarbonKeyEvent *) keyEvent; {
	NSNumber * key = [self keyForKeyCode:keyEvent.keyCode modifierFlags:keyEvent.modifierFlags];
	return self.keyEvents[key] != NULL;
}

- (BOOL) hasCarbonKeyEventWithKeyCode:(NSUInteger) keyCode modifierFlags:(NSUInteger) modifierFlags; {
	NSNumber * key = [self keyForKeyCode:keyCode modifierFlags:modifierFlags];
	return self.keyEvents[key] != NULL;
}

- (void) removeAllEvents {
	NSArray * keyEvents = [self allKeyEvents];
	for(CarbonKeyEvent * keyEvent in keyEvents) {
		[self removeCarbonKeyEvent:keyEvent];
	}
	[self saveToDefaults];
}

- (void) dealloc {
	self.writesToDefaults = FALSE;
	[self removeAllEvents];
}

@end

@implementation CarbonKeyEvent

+ (instancetype) carbonEventWithKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers; {
	CarbonKeyEvent * event = [[CarbonKeyEvent alloc] init];
	event.keyCode = keyCode;
	event.modifierFlags = modifiers;
	return event;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	NSKeyedUnarchiver * unarchiver = (NSKeyedUnarchiver *)aDecoder;
	self.keyCode = [[unarchiver decodeObjectForKey:@"keyCode"] unsignedIntegerValue];
	self.modifierFlags = [[unarchiver decodeObjectForKey:@"modifierFlags"] unsignedIntegerValue];
	self.tag = [[unarchiver decodeObjectForKey:@"tag"] integerValue];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
	NSKeyedArchiver * archiver = (NSKeyedArchiver *)aCoder;
	[archiver encodeObject:[NSNumber numberWithUnsignedInteger:self.keyCode] forKey:@"keyCode"];
	[archiver encodeObject:[NSNumber numberWithUnsignedInteger:self.modifierFlags] forKey:@"modifierFlags"];
	[archiver encodeObject:[NSNumber numberWithInteger:self.tag] forKey:@"tag"];
}

- (void) invoke {
	if(!self.target) {
		NSLog(@"keyCode: %lu, withModifiers:%lu invoked but no target/action is available.",self.keyCode,self.modifierFlags);
	} else {
		[self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:FALSE];
	}
}

- (void) setTarget:(NSObject *) target action:(SEL) action; {
	self.target = target;
	self.action = action;
}

- (void) dealloc {
	//NSLog(@"DEALLOC: CarbonKeyEvent");
}

@end


#import "AccessibilityHelper.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));

#pragma mark AccessibilityElement Interface

@interface AccessibilityElement ()
@property AXUIElementRef element;
- (id) initWithAXUIElementRef:(AXUIElementRef) elementRef;
- (pid_t) pid;
@end

#pragma mark AccessibilityHelper

@implementation AccessibilityHelper

+ (void) logResultCode:(AXError) resultCode withMessage:(NSString *) message {
	if(resultCode == kAXErrorSuccess) {
		NSLog(@"%@: kAXErrorSuccess",message);
	} else if(resultCode == kAXErrorAttributeUnsupported) {
		NSLog(@"%@: kAXErrorAttributeUnsupported",message);
	} else if(resultCode == kAXErrorNoValue) {
		NSLog(@"%@: kAXErrorNoValue",message);
	} else if(resultCode == kAXErrorIllegalArgument) {
		NSLog(@"%@: kAXErrorIllegalArgument",message);
	} else if(resultCode == kAXErrorInvalidUIElement) {
		NSLog(@"%@: kAXErrorInvalidUIElement",message);
	} else if(resultCode == kAXErrorCannotComplete) {
		NSLog(@"%@: kAXErrorCannotComplete",message);
	} else if(resultCode == kAXErrorNotImplemented) {
		NSLog(@"%@: kAXErrorNotImplemented",message);
	}
}

+ (BOOL) accessibilityEnabled {
	return AXIsProcessTrusted();
}

+ (BOOL) accessibilityEnabledWithPrompt {
	if(AXIsProcessTrustedWithOptions != NULL) {
		NSDictionary * options = @{(__bridge id)kAXTrustedCheckOptionPrompt:@YES};
		BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
		return accessibilityEnabled;
	} else {
		return AXIsProcessTrusted();
	}
	return FALSE;
}

+ (AccessibilityElement *) systemElement; {
	AXUIElementRef sys = AXUIElementCreateSystemWide();
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:sys];
	CFRelease(sys);
	return element;
}

+ (AccessibilityElement *) applicationFromSystemElement {
	CFTypeRef res = NULL;
	AXUIElementRef sys = AXUIElementCreateSystemWide();
	int result = AXUIElementCopyAttributeValue(sys,(CFStringRef)kAXFocusedApplicationAttribute,(CFTypeRef *)&res);
	if(result != kAXErrorSuccess) {
		CFRelease(sys);
		[self logResultCode:result withMessage:@"can't copy attribute kAXFocusedApplicationAttribute"];
		return nil;
	}
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:(AXUIElementRef)res];
	CFRelease(sys);
	return element;
}

+ (AccessibilityElement *) applicationElementFromPid:(pid_t) pid; {
	AXUIElementRef ref = AXUIElementCreateApplication(pid);
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:ref];
	CFRelease(ref);
	return element;
}

+ (AccessibilityElement *) focusedWindowForApplicationFromSystemElement {
	AccessibilityElement * application = [AccessibilityHelper applicationFromSystemElement];
	if(!application) {
		return nil;
	}
	AXUIElementRef res = NULL;
	int result = AXUIElementCopyAttributeValue(application.element,kAXFocusedWindowAttribute,(CFTypeRef *)&res);
	if(result != kAXErrorSuccess) {
		CFRelease(res);
		[self logResultCode:result withMessage:@"can't copy attribute NSAccessibilityFocusedWindowAttribute"];
		return nil;
	}
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:res];
	CFRelease(res);
	return element;
}

+ (AccessibilityElement *) focusedWindowForApplicationElementFromPid:(pid_t) pid {
	AccessibilityElement * applicationElement = [self applicationElementFromPid:pid];
	if(!applicationElement) {
		return nil;
	}
	AccessibilityElement * windowElement = [applicationElement accessibilityElementForAttribute:NSAccessibilityFocusedWindowAttribute];
	if(!windowElement) {
		return nil;
	}
	return windowElement;
}

@end

#pragma mark AccessibilityObserver Interface

@interface AccessibilityObserver ()
@property AXObserverRef observer;
@property (weak) AccessibilityElement * element;
@end

#pragma mark AccessibilityObserver Implementation

static void AccessibilityObserverCallback(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void * userInfo) {
	AccessibilityObserver * axobserver = (__bridge AccessibilityObserver *)userInfo;
	axobserver.callback(axobserver,axobserver.element,(__bridge NSString *)notification);
}

@implementation AccessibilityObserver

+ (instancetype) observerForNotification:(NSString *) notification withCallback:(AccessibilityNotificationCallback) callback; {
	AccessibilityObserver * observer = [[AccessibilityObserver alloc] init];
	observer.notification = notification;
	observer.callback = callback;
	return observer;
}

- (void) installObserver {
	AXObserverRef ref;
	AXObserverCreate([self.element pid],AccessibilityObserverCallback,&ref);
	CFRunLoopAddSource([[NSRunLoop mainRunLoop] getCFRunLoop],AXObserverGetRunLoopSource(ref),(__bridge CFStringRef)NSDefaultRunLoopMode);
	self.observer = ref;
	AXObserverAddNotification(ref,self.element.element,(__bridge CFStringRef)self.notification,(__bridge void *)self);
}

- (void) uninstallObserver {
	if(self.observer) {
		CFRunLoopRemoveSource([[NSRunLoop mainRunLoop] getCFRunLoop],AXObserverGetRunLoopSource(self.observer),(CFStringRef)NSDefaultRunLoopMode);
		AXObserverRemoveNotification(self.observer,self.element.element,(__bridge CFStringRef)self.notification);
		CFRelease(self.observer);
		self.observer = nil;
	}
}

- (void) dealloc {
	[self uninstallObserver];
	self.element = nil;
}

@end

#pragma mark AccessibilityElement Implementation

@interface AccessibilityElement ()
@property NSMutableArray * observers;
@end

@implementation AccessibilityElement

+ (AccessibilityElement *) elementWithAXUIElementRef:(AXUIElementRef) elementRef {
	AccessibilityElement * element = [[AccessibilityElement alloc] initWithAXUIElementRef:elementRef];
	return element;
}

- (id) initWithAXUIElementRef:(AXUIElementRef) elementRef; {
	self = [super init];
	CFRetain(elementRef);
	self.observers = [NSMutableArray array];
	self.element = elementRef;
	return self;
}

- (pid_t) pid; {
	pid_t p;
	int res = AXUIElementGetPid(self.element,&p);
	if(res == kAXErrorInvalidUIElement || res == kAXErrorIllegalArgument) return -1;
	return p;
}

- (BOOL) actsAsRole:(NSString *) role {
	NSString * elementRole = [self stringValueForAttribute:NSAccessibilityRoleAttribute];
	return ([elementRole isEqualToString:role]);
}

- (AccessibilityElement *) accessibilityElementForAttribute:(NSString *) attribute; {
	AXUIElementRef value = NULL;
	int resc = AXUIElementCopyAttributeValue((AXUIElementRef)self.element,(__bridge CFStringRef)attribute,(CFTypeRef *)&value);
	if(resc != kAXErrorSuccess) {
		return nil;
	}
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:(AXUIElementRef)value];
	CFRelease(value);
	return element;
}

- (NSValue *) NSValueForAttribute:(NSString *) attribute; {
	CFTypeRef value = NULL;
	int resc = AXUIElementCopyAttributeValue((AXUIElementRef)self.element,(__bridge CFStringRef)attribute,&value);
	if(resc != kAXErrorSuccess) {
		return nil;
	}
	NSValue * nsvalue = nil;
	AXValueType valueType = AXValueGetType((AXValueRef)value);
	if(valueType == kAXValueCGPointType) {
		CGPoint res;
		AXValueGetValue((AXValueRef)value,valueType,&res);
		NSPoint nspoint = NSMakePoint(res.x,res.y);
		nsvalue = [NSValue valueWithPoint:nspoint];
	} else if(valueType == kAXValueCFRangeType) {
		CFRange range;
		AXValueGetValue((AXValueRef)value,valueType,&range);
		NSRange nsrange = NSMakeRange(range.location,range.length);
		nsvalue = [NSValue valueWithRange:nsrange];
	} else if(valueType == kAXValueCGRectType) {
		CGRect rect;
		AXValueGetValue((AXValueRef)value,valueType,&rect);
		NSRect nsrect = NSMakeRect(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
		nsvalue = [NSValue valueWithRect:nsrect];
	} else if(valueType == kAXValueCGSizeType) {
		CGSize size;
		AXValueGetValue((AXValueRef)value,valueType,&size);
		NSSize nssize = NSMakeSize(size.width,size.height);
		nsvalue = [NSValue valueWithSize:nssize];
	}
	CFRelease(value);
	return nsvalue;
}

- (NSString *) stringValueForAttribute:(NSString *) attribute; {
	CFTypeRef value = NULL;
	int resc = AXUIElementCopyAttributeValue((AXUIElementRef)self.element,(__bridge CFStringRef)attribute,&value);
	if(resc != kAXErrorSuccess) {
		return nil;
	}
	NSString * nsvalue = CFBridgingRelease(value);
	return nsvalue;
}

- (void) setNSValue:(NSValue *) value forAttribute:(NSString *) attribute; {
	const char * objcType = [value objCType];
	if(strcmp(objcType, @encode(NSPoint)) == 0) {
		NSPoint point = value.pointValue;
		AXValueRef pointValue = AXValueCreate(kAXValueCGPointType,&point);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,pointValue);
		CFRelease(pointValue);
	} else if(strcmp(objcType,@encode(NSSize)) == 0) {
		NSSize size = value.sizeValue;
		AXValueRef sizeValue = AXValueCreate(kAXValueCGSizeType,&size);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,sizeValue);
		CFRelease(sizeValue);
	} else if(strcmp(objcType,@encode(NSRect)) == 0) {
		NSRect rect = value.rectValue;
		AXValueRef rectValue = AXValueCreate(kAXValueCGRectType,&rect);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,rectValue);
		CFRelease(rectValue);
	} else if(strcmp(objcType,@encode(NSRange)) == 0) {
		NSRange range = value.rangeValue;
		AXValueRef rangeValue = AXValueCreate(kAXValueCFRangeType,&range);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,rangeValue);
		CFRelease(rangeValue);
	}
}

- (void) setStringValue:(NSString *) value forAttribute:(NSString *) attribute; {
	AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,(__bridge CFTypeRef)value);
}

- (BOOL) isAttributeSettable:(NSString *) attribute; {
	Boolean val = FALSE;
	if(AXUIElementIsAttributeSettable(self.element,(__bridge CFStringRef)attribute,&val) != kAXErrorSuccess) {
		return FALSE;
	}
	return val;
}

- (BOOL) areAttributesSettable:(NSArray *) attributes {
	for(NSString * attr in attributes) {
		if(![self isAttributeSettable:attr]) {
			return FALSE;
		}
	}
	return TRUE;
}

- (void) addObserver:(AccessibilityObserver *) observer; {
	if(observer.element) {
		[observer uninstallObserver];
	}
	[self.observers addObject:observer];
	observer.element = self;
	[observer installObserver];
}

- (void) removeObserver:(AccessibilityObserver *) observer; {
	[observer uninstallObserver];
	[self.observers removeObject:observer];
}

- (void) removeAllObservers {
	NSArray * observersCopy = [self.observers copy];
	for(AccessibilityObserver * observer in observersCopy) {
		[self removeObserver:observer];
	}
}

- (void) dealloc {
	[self removeAllObservers];
	CFRelease(self.element);
}

@end


#import "AccessibilityHelper.h"

extern Boolean AXIsProcessTrustedWithOptions(CFDictionaryRef options) __attribute__((weak_import));

#pragma mark AccessibilityElement Interface

@interface AccessibilityElement ()
@property AXUIElementRef element;
- (id) initWithAXUIElementRef:(AXUIElementRef) elementRef;
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
		[self logResultCode:result withMessage:@"can't copy attribute kAXFocusedApplicationAttribute"];
		return nil;
	}
	CFRelease(sys);
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:(AXUIElementRef)res];
	return element;
}

+ (AccessibilityElement *) applicationElementFromPid:(pid_t) pid; {
	AXUIElementRef ref = AXUIElementCreateApplication(pid);
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:ref];
	CFRelease((CFTypeRef)ref);
	return element;
}

+ (AccessibilityElement *) focusedWindowForApplicationFromSystemElement {
	AccessibilityElement * application = [AccessibilityHelper applicationFromSystemElement];
	if(!application) {
		return nil;
	}
	CFTypeRef res = NULL;
	int result = AXUIElementCopyAttributeValue(application.element,kAXFocusedWindowAttribute,(CFTypeRef *)&res);
	if(result != kAXErrorSuccess) {
		[self logResultCode:result withMessage:@"can't copy attribute NSAccessibilityFocusedWindowAttribute"];
		return nil;
	}
	AccessibilityElement * element = [AccessibilityElement elementWithAXUIElementRef:(AXUIElementRef)res];
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
@property AccessibilityElement * element;
@end

#pragma mark AccessibilityObserver Implementation

@implementation AccessibilityObserver
+ (instancetype) observerForNotification:(NSString *) notification withCallback:(AccessibilityNotificationCallback) callback; {
	AccessibilityObserver * observer = [[AccessibilityObserver alloc] init];
	observer.notification = notification;
	observer.callback = callback;
	return observer;
}
- (void) dealloc {
	CFRunLoopRemoveSource([[NSRunLoop mainRunLoop] getCFRunLoop],AXObserverGetRunLoopSource(self.observer),(CFStringRef)NSDefaultRunLoopMode);
	AXObserverRemoveNotification(self.observer,self.element.element,(__bridge CFStringRef)self.notification);
	self.element = nil;
}
@end

static void AccessibilityObserverCallback(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void * userInfo) {
	AccessibilityObserver * axobserver = (__bridge AccessibilityObserver *)userInfo;
	axobserver.callback(axobserver,axobserver.element,(__bridge NSString *)notification);
}

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
	CFTypeRef value = NULL;
	int resc = AXUIElementCopyAttributeValue((AXUIElementRef)self.element,(__bridge CFStringRef)attribute,&value);
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
	return (__bridge  NSString *)value;
}

- (void) setNSValue:(NSValue *) value forAttribute:(NSString *) attribute; {
	const char * objcType = [value objCType];
	if(strcmp(objcType, @encode(NSPoint)) == 0) {
		NSPoint point = value.pointValue;
		AXValueRef pointValue = AXValueCreate(kAXValueCGPointType,&point);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,pointValue);
	} else if(strcmp(objcType,@encode(NSSize)) == 0) {
		NSSize size = value.sizeValue;
		AXValueRef sizeValue = AXValueCreate(kAXValueCGSizeType,&size);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,sizeValue);
	} else if(strcmp(objcType,@encode(NSRect)) == 0) {
		NSRect rect = value.rectValue;
		AXValueRef rectValue = AXValueCreate(kAXValueCGSizeType,&rect);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,rectValue);
	} else if(strcmp(objcType,@encode(NSRange)) == 0) {
		NSRange range = value.rangeValue;
		AXValueRef rangeValue = AXValueCreate(kAXValueCGSizeType,&range);
		AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,rangeValue);
	}
}

- (void) setStringValue:(NSString *) value forAttribute:(NSString *) attribute; {
	AXUIElementSetAttributeValue(self.element,(__bridge CFStringRef)attribute,(__bridge CFTypeRef)value);
}

- (void) addObserver:(AccessibilityObserver *) observer; {
	AXObserverRef ref;
	AXObserverCreate([self pid],AccessibilityObserverCallback,&ref);
	CFRunLoopAddSource([[NSRunLoop mainRunLoop] getCFRunLoop],AXObserverGetRunLoopSource(ref),(__bridge CFStringRef)NSDefaultRunLoopMode);
	observer.observer = ref;
	observer.element = self;
	AXObserverAddNotification(ref,self.element,(__bridge CFStringRef)observer.notification,(__bridge void *)observer);
	[self.observers addObject:observer];
}

- (void) removeObserver:(AccessibilityObserver *) observer; {
	[self.observers removeObject:observer];
	CFRunLoopRemoveSource([[NSRunLoop mainRunLoop] getCFRunLoop],AXObserverGetRunLoopSource(observer.observer),(CFStringRef)NSDefaultRunLoopMode);
	AXObserverRemoveNotification(observer.observer,self.element,(__bridge CFStringRef)observer.notification);
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

//copyright 2009 aaronsmith

#import "AccessibilityManager.h"

static AccessibilityManager * inst;

@implementation AccessibilityManager

+ (AccessibilityManager *) sharedInstance {
    @synchronized(self) {
		if(!inst) {
			inst=[[self alloc] init];
		}
    }
    return inst;
}

- (Boolean) isAccessibilityEnabled {
	return AXAPIEnabled();
}

//internal
- (AccessibilityOperationResult *) getAPIDisabledOperationResult {
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	[res setResultCode:kAXErrorAPIDisabled];
	return res;
}

//internal
- (AccessibilityOperationResult *) getCannotCreateValueOperationResult {
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	[res setResultCode:kAMCouldNotSetValue];
	return res;
}


- (AccessibilityOperationResult *) sysWide {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult *res = [[[AccessibilityOperationResult alloc] init] autorelease];
	AXUIElementRef ref = AXUIElementCreateSystemWide();
	[res setResultCode:kAXErrorSuccess];
	if([res wasSuccess]) {
		[res setResult:(CFTypeRef)ref];
		CFRelease((CFTypeRef)ref);
	}
	return res;
}

- (AccessibilityOperationResult *) focusedApplicationRef {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult *result = [[[AccessibilityOperationResult alloc] init] autorelease];
	CFTypeRef res = NULL;
	AXUIElementRef sys = AXUIElementCreateSystemWide();
	int rescode = AXUIElementCopyAttributeValue(sys,(CFStringRef)kAXFocusedApplicationAttribute,(CFTypeRef *)&res);
	CFRelease(sys);
	[result setResultCode:rescode];
	if([result wasSuccess]) {
		[result setResult:res];
		CFRelease(res);
	}
	return result;
}

- (AccessibilityOperationResult *) applicationRefFromPid:(pid_t) pid {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * result = [[[AccessibilityOperationResult alloc] init] autorelease];
	CFTypeRef res = AXUIElementCreateApplication(pid);
	[result setResultCode:kAXErrorSuccess];
	if([result wasSuccess]) {
		[result setResult:res];
		CFRelease(res);
	}
	return result;
}

- (pid_t) forAXUIElementRefGetPID:(AXUIElementRef) element {
	pid_t p;
	int res = AXUIElementGetPid(element,&p);
	if(res == kAXErrorInvalidUIElement || res == kAXErrorIllegalArgument) return -1;
	return (pid_t)p;
}

- (AccessibilityOperationResult *) focusedWindowForApplication:(AXUIElementRef) applicationRef {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult *result = [[[AccessibilityOperationResult alloc] init] autorelease];
	CFTypeRef res = NULL;
	if(![self doesElementRef:applicationRef actAsRole:NSAccessibilityApplicationRole]) {
		[result setResultCode:kAMIncorrectRole];
	} else {
		int rescode = AXUIElementCopyAttributeValue(applicationRef,(CFStringRef)NSAccessibilityFocusedWindowAttribute,(CFTypeRef *)&res);
		[result setResultCode:rescode];
	}
	if([result wasSuccess]) {
		[result setResult:res];
		CFRelease(res);
	}
	return result;
}

- (Boolean) doesElementRef:(AXUIElementRef) element actAsRole:(NSString *) role {
	AccessibilityOperationResult * res = [self forAXUIElementRefGetRoleAttribute:element];
	if(![res wasSuccess]) return FALSE;
	return ([(NSString *)[res result] isEqualTo:role]);
}

- (AccessibilityOperationResult *) focusedWindowForFocusedApplication {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * result;
	AccessibilityOperationResult * app = [self focusedApplicationRef];
	if([app wasSuccess]) {
		result = [self focusedWindowForApplication:[app result]];
	} else {
		result = [[[AccessibilityOperationResult alloc] init] autorelease];
		[result setResultCode:[app resultCode]];
	}
	return result;
}

- (AccessibilityOperationResult *) forAXUIElementRefGetRoleAttribute:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	return [self forAXUIElementRef:element getAttributeValue:NSAccessibilityRoleAttribute];
}

- (AccessibilityOperationResult *) forAXUIElementRefGetRoleDescriptionAttribute:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	return [self forAXUIElementRef:element getAttributeValue:NSAccessibilityRoleDescriptionAttribute];
}

- (AccessibilityOperationResult *) forAXUIElementRefGetTitleAttribute:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	return [self forAXUIElementRef:element getAttributeValue:NSAccessibilityTitleAttribute];
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef)element getAttributeValue:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	CFTypeRef *value = NULL;
	int resc = AXUIElementCopyAttributeValue((AXUIElementRef)element,(CFStringRef)attribute,(CFTypeRef*)&value);
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:value];
		CFRelease(value);
	}
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getAttributeValueCount:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	CFIndex * count;
	int resc = AXUIElementGetAttributeValueCount((AXUIElementRef)element,(CFStringRef)attribute,(CFIndex*)&count);
	[res setResultCode:resc];
	if([res wasSuccess]) [res setResult:(CFTypeRef)count];
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSPoint:(NSPoint) point {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	AXValueRef valueRef = AXValueCreate(kAXValueCGPointType,(const void *)&point);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSRect:(NSRect) rect {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	AXValueRef valueRef = AXValueCreate(kAXValueCGRectType,(const void *)&rect);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSRange:(NSRange) range {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	AXValueRef valueRef = AXValueCreate(kAXValueCFRangeType,(const void *)&range);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSSize:(NSSize) size {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	AXValueRef valueRef = AXValueCreate(kAXValueCGSizeType,(const void *)&size);
	if(!valueRef) return [self getCannotCreateValueOperationResult];
	int resc = AXUIElementSetAttributeValue(element,(CFStringRef)attribute,(CFTypeRef)valueRef);
	CFRelease(valueRef);
	[res setResultCode:resc];
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSString:(NSString *) string {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	int resc = AXUIElementSetAttributeValue(element,(CFStringRef)attribute,(CFTypeRef)string);
	[res setResultCode:resc];
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element setAttribute:(NSString *) attribute toNSValue:(NSValue *) nsvalue {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSPoint)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSPoint:[nsvalue pointValue]];
	} else if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSRect)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSRect:[nsvalue rectValue]];
	} else if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSRange)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSRange:[nsvalue rangeValue]];
	} else if(strcmp((const char *)[nsvalue objCType],(const char *)@encode(NSSize)) == 0) {
		return [self forAXUIElementRef:element setAttribute:attribute toNSSize:[nsvalue sizeValue]];
	}
	AccessibilityOperationResult * failedRes = [[[AccessibilityOperationResult alloc] init] autorelease];
	[failedRes setResultCode:kAMIncorrectValue];
	return failedRes;
}

- (Boolean) isAXUIElementRef:(AXUIElementRef) element attributeSettable:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return FALSE;
	Boolean val = FALSE;
	if(AXUIElementIsAttributeSettable(element,(CFStringRef)attribute,&val) != kAXErrorSuccess) {
		return FALSE;
	}
	return val;
}

- (Boolean) doesElementRef:(AXUIElementRef) elementRef exposeAttribute:(NSString *) attribute {
	if(![self isAccessibilityEnabled]) return FALSE;
	NSArray *attributes = NULL;
	Boolean does = false;
	if(AXUIElementCopyAttributeNames(elementRef,(CFArrayRef *)&attributes) == kAXErrorSuccess) {
		does = [attributes containsObject:attribute];
		[attributes release];
	}
	return does;
}

- (AccessibilityOperationResult *) forAXUIElementRefGetAttributeNames:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	NSArray * result;
	int resc = AXUIElementCopyAttributeNames(element,(CFArrayRef*)&result);
	AccessibilityOperationResult *res = [[[AccessibilityOperationResult alloc] init] autorelease];
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:(CFTypeRef)result];
		[result release];
	}
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRefGetActionNames:(AXUIElementRef) element {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	NSArray * result;
	int resc = AXUIElementCopyActionNames(element,(CFArrayRef*)&result);
	AccessibilityOperationResult *res = [[[AccessibilityOperationResult alloc] init] autorelease];
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:(CFTypeRef)result];
		[result release];
	}
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element getActionDescription:(NSString *) action {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	NSString * desc;
	int resc = AXUIElementCopyActionDescription(element,(CFStringRef)action,(CFStringRef*)&desc);
	AccessibilityOperationResult *res = [[[AccessibilityOperationResult alloc] init] autorelease];
	[res setResultCode:resc];
	if([res wasSuccess]) {
		[res setResult:(CFTypeRef)desc];
		[desc release];
	}
	return res;
}

- (AccessibilityOperationResult *) forAXUIElementRef:(AXUIElementRef) element performAction:(NSString *) action {
	if(![self isAccessibilityEnabled]) return [self getAPIDisabledOperationResult];
	int resc = AXUIElementPerformAction(element,(CFStringRef)action);
	AccessibilityOperationResult * res = [[[AccessibilityOperationResult alloc] init] autorelease];
	[res setResultCode:resc];
	return res;
}

- (Boolean) isCGPoint:(CFTypeRef) possibleCGPointRef {
	return (AXValueGetType((AXValueRef)possibleCGPointRef) == kAXValueCGPointType);
}

- (Boolean) isCGRect:(CFTypeRef) possibleCGRectRef {
	return (AXValueGetType((AXValueRef)possibleCGRectRef) == kAXValueCGRectType);
}

- (Boolean) isCGSize:(CFTypeRef) possibleCGSize {
	return (AXValueGetType((AXValueRef)possibleCGSize) == kAXValueCGSizeType);
}

- (Boolean) isCFRange:(CFTypeRef) possibleCFRange {
	return (AXValueGetType((AXValueRef)possibleCFRange) == kAXValueCFRangeType);
}

- (Boolean) isNSString:(CFTypeRef) possibleString {
	return ([(id)possibleString isKindOfClass:[NSString class]]);
}

- (Boolean) isNSValue:(CFTypeRef) possibleNSValue {
	return ([(id)possibleNSValue isKindOfClass:[NSValue class]]);
}

+ (id)allocWithZone:(NSZone *) zone {
    @synchronized(self) {
		if (inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *) zone {
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger) retainCount {
	return UINT_MAX;
}

- (id) autorelease {
	return self;
}

- (void) release{
}

@end

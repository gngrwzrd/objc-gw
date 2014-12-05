
#import <Cocoa/Cocoa.h>

@class AccessibilityElement;
@class AccessibilityObserver;

@interface AccessibilityHelper : NSObject
+ (BOOL) accessibilityEnabled;
+ (BOOL) accessibilityEnabledWithPrompt;
+ (AccessibilityElement *) systemElement;
+ (AccessibilityElement *) applicationElementFromPid:(pid_t) pid;
+ (AccessibilityElement *) applicationFromSystemElement;
+ (AccessibilityElement *) focusedWindowForApplicationFromSystemElement;
+ (AccessibilityElement *) focusedWindowForApplicationElementFromPid:(pid_t) pid;
@end

typedef void (^AccessibilityNotificationCallback)(AccessibilityObserver * observer, AccessibilityElement * element, NSString * notification);

@interface AccessibilityElement : NSObject
+ (AccessibilityElement *) elementWithAXUIElementRef:(AXUIElementRef) elementRef;
- (AccessibilityElement *) accessibilityElementForAttribute:(NSString *) attribute;
- (NSValue *) NSValueForAttribute:(NSString *) attribute;
- (NSString *) stringValueForAttribute:(NSString *) attribute;
- (void) setNSValue:(NSValue *) value forAttribute:(NSString *) attribute;
- (void) setStringValue:(NSString *) value forAttribute:(NSString *) attribute;
- (void) addObserver:(AccessibilityObserver *) observer;
- (void) removeObserver:(AccessibilityObserver *) observer;
@end

@interface AccessibilityObserver : NSObject
+ (AccessibilityObserver *) observerForNotification:(NSString *) notification withCallback:(AccessibilityNotificationCallback) callback;
@property NSString * notification;
@property (strong) AccessibilityNotificationCallback callback;
@end

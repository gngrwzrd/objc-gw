//copyright 2009 aaronsmith

#import <Cocoa/Cocoa.h>
#import "AccessibilityManager.h"
#import "AccessibilityNotification.h"
#import "AccessibilityObserver.h"


/**
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html#//apple_ref/c/func/AXObserverCreate
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html#//apple_ref/c/func/AXObserverAddNotification
 * @see http://developer.apple.com/mac/library/documentation/Accessibility/Reference/AccessibilityLowlevel/AXUIElement_h/CompositePage.html#//apple_ref/c/func/AXObserverGetRunLoopSource
 * @see http://developer.apple.com/mac/library/documentation/Cocoa/Reference/ApplicationKit/Miscellaneous/AppKit_Functions/Reference/reference.html#//apple_ref/c/func/NSAccessibilityPostNotification
 * @see Also see carbon run loops and CFRunLoopAddSource().
 */
@interface AccessibilityObserver : NSObject {
	
	/**
	 * The application's pid.
	 */
	pid_t app_pid;
	
	/**
	 * The target for the notification callback.
	 */
	id actionTarget;
	
	/**
	 * The selector on the callback target.
	 */
	SEL actionSelector;
	
	/**
	 * An accessibility observer reference.
	 */
	AXObserverRef observer;
	
	/**
	 * The accessibility element reference.
	 */
	AXUIElementRef element;
	
	/**
	 * An invoker that calls the target/selector when the accessibility
	 * notification occurs.
	 */
	NSInvocation * invoker;
	
	/**
	 * Method signature for the callback selector.
	 */
	NSMethodSignature * selectorSignature;
	
	/**
	 * User info dictionary passed on notification.
	 */
	NSDictionary * userInfo;
	
	/**
	 * The notification name.
	 */
	NSString * notification;
	
	/**
	 * Singleton instance of the AccessibilityManager.
	 */
	AccessibilityManager * accessManager;
	
	/**
	 * An instance of an AccessibilityNotification.
	 */
	AccessibilityNotification * notify;
}

/**
 * Designated initializer - init with required parameters.
 *
 * @param notification The notification to subscribe to.
 * @param element The AXUIElementRef to listen for posted notifications from.
 * @param action A callback selector.
 * @param target A callback target object.
 * @param userInpho A user info dictionary.
 */
- (id) initWithNotification:(NSString *) notification forAXUIElementRef:(AXUIElementRef) element callsAction:(SEL) action onTarget:(id) target withUserInfo:(NSDictionary *) userInpho;

@end

@interface  AccessibilityObserver (Private)

//returns the invoker for this observer.
- (NSInvocation *) invoker;

@end

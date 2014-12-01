
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface QuartzKeyEvent : NSObject
@property NSUInteger tag;
@property NSUInteger keyCode;
@property NSEventModifierFlags modifiers;
@property NSObject * target;
@property SEL action;
+ (instancetype) eventWithKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers;
@end

typedef void (^QuartzEventManagerRestoreTargetAction)(QuartzKeyEvent * event);

@interface QuartzKeyEventManager : NSObject
+ (QuartzKeyEventManager *) sharedManager;
- (void) restoreTargetActions:(QuartzEventManagerRestoreTargetAction) callback;
- (void) addQuartzKeyEvent:(QuartzKeyEvent *) event;
- (void) removeQuartzKeyEvent:(QuartzKeyEvent *) event;
- (void) removeQuartzKeyEventForKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers;
- (void) startEventTap;
- (void) stopEventTap;
- (BOOL) hasKeyEvent:(QuartzKeyEvent *) event;
- (BOOL) hasKeyEventForKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers;
@end

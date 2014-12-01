
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface CarbonKeyEvent : NSObject <NSCoding>
@property NSInteger tag;
@property NSEventModifierFlags modifierFlags;
@property NSUInteger keyCode;
@property NSObject * target;
@property SEL action;
+ (instancetype) carbonEventWithKeyCode:(NSUInteger) keyCode modifiers:(NSEventModifierFlags) modifiers;
- (void) invoke;
- (void) setTarget:(NSObject *) target action:(SEL) action;
@end

typedef void (^CarbonEventManagerRestoreTargetAction)(CarbonKeyEvent * event);

@interface CarbonEventManager : NSObject
@property BOOL writesToDefaults;
+ (CarbonEventManager *) sharedManager;
+ (NSUInteger) carbonToCocoaModifierFlags:(NSUInteger) carbonFlags;
+ (NSUInteger) cocoaToCarbonModifierFlags:(NSUInteger) cocoaFlags;
- (void) restoreTargetActions:(CarbonEventManagerRestoreTargetAction) restoreHandler;
- (void) addCarbonKeyEvent:(CarbonKeyEvent *) keyEvent;
- (void) removeCarbonKeyEvent:(CarbonKeyEvent *) keyEvent;
- (void) removeCarbonKeyEventWithKeyCode:(NSUInteger) keyCode modifierFlags:(NSUInteger) modifierFlags;
- (BOOL) hasCarbonKeyEvent:(CarbonKeyEvent *) keyEvent;
- (BOOL) hasKeyCode:(NSUInteger) keyCode modifierFlags:(NSUInteger) modifierFlags;
- (void) removeAllEvents;
- (void) saveToDefaults;
- (void) restoreFromDefaults;
- (NSData *) keyEventsData;
- (void) restoreKeyEventsFromData:(NSData *) data;
@end

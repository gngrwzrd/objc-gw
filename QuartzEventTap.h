
#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@class QuartzEventTap;
typedef CGEventRef (^QuartzEventTapCallback)(CGEventTapProxy proxy, CGEventType type, CGEventRef event, QuartzEventTap * refcon);
@interface QuartzEventTap : NSObject
@property BOOL isRunning;
@property (strong) QuartzEventTapCallback callback;
@property CGEventTapLocation eventTapLocation;
@property CGEventTapPlacement eventTapPlacement;
@property CGEventTapOptions eventTapOptions;
@property CGEventMask eventTapEvents;
- (void) start;
- (void) stop;
@end

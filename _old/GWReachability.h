
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

NSString * const GWReachabilityConnected;
NSString * const GWReachabilityDisconnected;

@class GWReachability;

@protocol GWReachabilityDelegate <NSObject>
- (void) reachabilityConnected:(GWReachability *) reachability;
- (void) reachabilityDisconnected:(GWReachability *) reachability;
@end

@interface GWReachability : NSObject {
	SCNetworkReachabilityRef _reach;
	SCNetworkReachabilityContext _reachContext;
	dispatch_queue_t _queue;
}

@property (assign) NSObject <GWReachabilityDelegate> * delegate;
@property SCNetworkReachabilityFlags flags;

+ (instancetype) reachability;
- (id) initWithNodeName:(NSString *) nodeName;
- (void) startUpdating;
- (void) stopUpdating;
- (BOOL) isConnected;
- (BOOL) connectionRequired;

@end

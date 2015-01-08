
#import "GWReachability.h"

NSString * const GWReachabilityConnected = @"GWReachabilityConnected";
NSString * const GWReachabilityDisconnected = @"GWReachabilityDisconnected";

@interface GWReachability ()
- (void) reachUpdateWithFlags:(NSNumber *) flags;
@end

void GWReachabilityCallback(SCNetworkReachabilityRef target,SCNetworkReachabilityFlags flags,void *info) {
	GWReachability * reach = (__bridge GWReachability *)info;
	[reach performSelectorOnMainThread:@selector(reachUpdateWithFlags:) withObject:@(flags) waitUntilDone:FALSE];
}

static GWReachability * instance = nil;

@implementation GWReachability

+ (instancetype) reachability {
	return instance;
}

- (id) initWithNodeName:(NSString *) nodeName {
	self = [super init];
	
	_reach = SCNetworkReachabilityCreateWithName(NULL,[nodeName UTF8String]);
	if(!_reach) {
		return nil;
	}
	
	SCNetworkReachabilityFlags flags = 0;
	SCNetworkReachabilityGetFlags(_reach,&flags);
	self.flags = flags;
	
	_queue = dispatch_queue_create("com.gngrwzrd.GWReachability",NULL);
	if(!_queue) {
		return nil;
	}
	_reachContext.info = (__bridge void *)self;
	
	instance = self;
	
	return self;
}

- (void) startUpdating {
	SCNetworkReachabilitySetCallback(_reach,GWReachabilityCallback,&_reachContext);
	SCNetworkReachabilitySetDispatchQueue(_reach,_queue);
}

- (void) stopUpdating {
	SCNetworkReachabilitySetCallback(_reach,NULL,NULL);
	SCNetworkReachabilitySetDispatchQueue(_reach,NULL);
}

- (BOOL) isConnected {
	if((self.flags & kSCNetworkFlagsConnectionRequired) != 0) {
		return FALSE;
	}
	if((self.flags & kSCNetworkFlagsReachable) != 0) {
		return TRUE;
	}
	return FALSE;
}

- (BOOL) connectionRequired {
	return (self.flags & kSCNetworkFlagsConnectionRequired) != 0;
}

- (BOOL) isInterventionRequired {
	return (self.flags & kSCNetworkFlagsInterventionRequired) != 0;
}

- (void) reachUpdateWithFlags:(NSNumber *) flags {
	self.flags = (SCNetworkReachabilityFlags)[flags integerValue];

#if DEBUG
	NSLog(@"kSCNetworkFlagsReachable: %i", (self.flags & kSCNetworkFlagsReachable) != 0);
	NSLog(@"kSCNetworkFlagsConnectionAutomatic: %i",(self.flags & kSCNetworkFlagsConnectionAutomatic) != 0);
	NSLog(@"kSCNetworkFlagsConnectionRequired: %i",(self.flags & kSCNetworkFlagsConnectionRequired) != 0);
	NSLog(@"kSCNetworkFlagsInterventionRequired: %i",(self.flags & kSCNetworkFlagsInterventionRequired) != 0);
	NSLog(@"kSCNetworkFlagsIsDirect: %i",(self.flags & kSCNetworkFlagsIsDirect) != 0);
	NSLog(@"kSCNetworkFlagsIsLocalAddress: %i",(self.flags & kSCNetworkFlagsIsLocalAddress) != 0);
	NSLog(@"kSCNetworkFlagsTransientConnection: %i",(self.flags & kSCNetworkFlagsTransientConnection) != 0);
#endif
	
	if((self.flags & kSCNetworkFlagsConnectionRequired) != 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:GWReachabilityDisconnected object:self];
		if([self.delegate respondsToSelector:@selector(reachabilityDisconnected:)]) {
			[self.delegate reachabilityDisconnected:self];
		}
	} else if( (self.flags & kSCNetworkFlagsConnectionRequired) != 0 && (self.flags & kSCNetworkFlagsTransientConnection) != 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:GWReachabilityDisconnected object:self];
		if([self.delegate respondsToSelector:@selector(reachabilityDisconnected:)]) {
			[self.delegate reachabilityDisconnected:self];
		}
	} else if(self.flags & kSCNetworkFlagsReachable) {
		[[NSNotificationCenter defaultCenter] postNotificationName:GWReachabilityConnected object:self];
		if(self.delegate && [self.delegate respondsToSelector:@selector(reachabilityConnected:)]) {
			[self.delegate reachabilityConnected:self];
		}
	} else if(self.flags == 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:GWReachabilityDisconnected object:self];
		if([self.delegate respondsToSelector:@selector(reachabilityDisconnected:)]) {
			[self.delegate reachabilityDisconnected:self];
		}
	}
}

- (void) dealloc {
	NSLog(@"DEALLOC: GWReachability");
	CFRelease(_reach);
}

@end

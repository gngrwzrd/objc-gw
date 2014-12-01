//copyright 2009 aaronsmith

#import "ASLLogManager.h"
#import "ASLLog.h"

static ASLLogManager * inst = nil;

@implementation ASLLogManager

@synthesize enabled;

+ (ASLLogManager *) sharedInstance {
    @synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
    }
    return inst;
}

- (id) init {
	self=[super init];
	logs=[[NSMutableDictionary alloc] init];
	[self setEnabled:TRUE];
	return self;
}

- (void) setLog:(ASLLog *) log forKey:(NSString *) key {
	@synchronized(self) {
		if(!logs) logs = [[NSMutableDictionary alloc] init];
		[logs setObject:log	forKey:key];
	}
}

- (ASLLog *) getLogForKey:(NSString *) key {
	ASLLog * l;
	@synchronized(self) {
		l = (ASLLog *)[logs objectForKey:key];
	}
	return l;
}

+ (id)allocWithZone:(NSZone *) zone {
    @synchronized(self) {
		if(inst==nil) {
			inst=[super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *) zone {
	return self;
}

- (id) retain {
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


#import "ASLLogManager.h"
#import "ASLLog.h"

static ASLLogManager * inst = nil;

@interface ASLLogManager ()
@property NSMutableDictionary * logs;
@end

@implementation ASLLogManager

+ (ASLLogManager *) sharedInstance {
	dispatch_once_t once;
	dispatch_once(&once, ^{
		inst = [[self alloc] init];
	});
	return inst;
}

- (id) init {
	self = [super init];
	self.logs = [[NSMutableDictionary alloc] init];
	return self;
}

- (void) setLog:(ASLLog *) log forKey:(NSString *) key {
	[self.logs setObject:log forKey:key];
}

- (ASLLog *) getLogForKey:(NSString *) key {
	return (ASLLog *)[self.logs objectForKey:key];
}

@end

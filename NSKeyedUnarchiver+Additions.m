
#import "NSKeyedUnarchiver+Additions.h"

@implementation NSKeyedUnarchiver (Additions)

- (void) decodeEntireObject:(NSObject <NSCodingKeys> *) instance; {
	NSArray * keys = [instance archiveKeys];
	for(NSString * key in keys) {
		[instance setValue:[self decodeObjectForKey:key] forKey:key];
	}
}

@end

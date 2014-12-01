
#import "NSKeyedArchiver+Additions.h"

@implementation NSKeyedArchiver (Additions)

- (void) encodeEntireObject:(NSObject <NSCodingKeys> *) instance; {
	NSArray * keys = [instance archiveKeys];
	for(NSString * key in keys) {
		id val = [instance valueForKey:key];
		[self encodeObject:val forKey:key];
	}
}

@end

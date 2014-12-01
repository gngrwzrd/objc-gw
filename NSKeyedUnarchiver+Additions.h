
#import <Foundation/Foundation.h>
#import "NSCodingKeys.h"

@interface NSKeyedUnarchiver (Additions)
- (void) decodeEntireObject:(NSObject <NSCodingKeys> *) instance;
@end

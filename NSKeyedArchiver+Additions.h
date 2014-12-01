
#import <Foundation/Foundation.h>
#import "NSCodingKeys.h"

@interface NSKeyedArchiver (Additions)
- (void) encodeEntireObject:(NSObject <NSCodingKeys> *) instance;
@end

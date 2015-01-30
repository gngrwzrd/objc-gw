
#import <Foundation/Foundation.h>

@protocol NSCodingKeys <NSObject>
- (NSArray *) archiveKeys;
@end

@interface NSKeyedArchiver (Additions)
- (void) encodeEntireObject:(NSObject <NSCodingKeys> *) instance;
@end

@interface NSKeyedUnarchiver (Additions)
- (void) decodeEntireObject:(NSObject <NSCodingKeys> *) instance;
@end

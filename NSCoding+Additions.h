
#import <Foundation/Foundation.h>
#include <objc/objc-runtime.h>

@protocol NSCodingKeys <NSObject>
- (NSArray *) archiveKeys;
@end

@interface NSKeyedArchiver (Additions)
- (void) encodeEntireObject:(NSObject <NSCodingKeys> *) instance;
- (void) encodeArchiveKeys:(NSObject <NSCodingKeys> *) instance;
- (void) encodeArchiveKeysByPropertyTypes:(NSObject <NSCodingKeys> * ) instance;
@end

@interface NSKeyedUnarchiver (Additions)
- (void) decodeEntireObject:(NSObject <NSCodingKeys> *) instance;
- (void) decodeArchiveKeys:(NSObject <NSCodingKeys> *) instance;
- (void) decodeArchiveKeysByPropertyTypes:(NSObject <NSCodingKeys> *) instance;
@end

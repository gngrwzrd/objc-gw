
#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Additions)

- (NSString *) hmacSha256SignatureForHeaders:(NSArray *) array withSecret:(NSString *) secret;

@end

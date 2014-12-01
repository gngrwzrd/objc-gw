
#import <Foundation/Foundation.h>

@interface NSURLRequest (GWAdditions)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

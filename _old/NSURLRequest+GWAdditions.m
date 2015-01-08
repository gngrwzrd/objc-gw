
#import "NSURLRequest+GWAdditions.h"

@implementation NSURLRequest (GWAdditions)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host; {
#if DEBUG
	return TRUE;
#else
	return FALSE;
#endif
}

@end

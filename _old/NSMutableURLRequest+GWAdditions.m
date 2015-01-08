
#import "NSMutableURLRequest+GWAdditions.h"
#import <CommonCrypto/CommonCrypto.h>

NSString * NSURL_hmacSHA256(NSString *key, NSString *data) {
	const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
	unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	NSMutableString *result = [NSMutableString string];
	for (int i = 0; i < sizeof cHMAC; i++) {
		[result appendFormat:@"%02hhx", cHMAC[i]];
	}
    return result;
}

@implementation NSMutableURLRequest (GWAdditions)

- (NSString *) hmacSha256SignatureForHeaders:(NSArray *) array withSecret:(NSString *) secret; {
	NSMutableString * input = [NSMutableString string];
	for(NSInteger i = 0; i < array.count; i++) {
		NSString * key = array[i];
		NSString * value = [self valueForHTTPHeaderField:key];
		NSString * line = nil;
		if(i == array.count-1) {
			line = [NSString stringWithFormat:@"%@: %@",key.lowercaseString,value];
		} else {
			line = [NSString stringWithFormat:@"%@: %@\r\n",key.lowercaseString,value];
		}
		[input appendString:line];
	}
	NSString * signature = NSURL_hmacSHA256(secret,input);
	return signature;
}

@end

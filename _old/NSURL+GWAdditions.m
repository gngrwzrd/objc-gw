
#import "NSURL+GWAdditions.h"

@implementation NSURL (GWAdditions)

+ (NSURL *) secureHTTPURLWithString:(NSString *) string {
	NSURL * url = [NSURL URLWithString:string];
	if([url.scheme isEqualToString:@"http"]) {
		NSMutableString * newURL = [[NSMutableString alloc] init];
		[newURL appendString:@"https://"];
		[newURL appendString:url.host];
		[newURL appendString:url.path];
		[newURL appendString:@"/"];
		url = [NSURL URLWithString:newURL];
	}
	return url;
}

@end

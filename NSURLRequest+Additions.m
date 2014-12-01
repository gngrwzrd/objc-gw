
#import "NSURLRequest+Additions.h"

@implementation NSURLRequest (GWAdditions)

+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString*) host; {
#if DEBUG
	return TRUE;
#else
	return FALSE;
#endif
}

+ (NSURLRequest *) fileUploadRequestWithURL:(NSString *) url data:(NSData *) data fileName:(NSString *) fileName variables:(NSDictionary *) variables {
	NSMutableData * postData = [NSMutableData data];
	
	NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc] init];
	[urlRequest setURL:[NSURL URLWithString:url]];
	[urlRequest setHTTPMethod:@"POST"];
	
	NSString * myboundary = @"-14737809831466499882746641449";
	NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
	[urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	if(data) {
		[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[NSData dataWithData:data]];
		[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	if(variables) {
		for(NSString * key in variables) {
			NSString * parameterValue = [variables objectForKey:key];
			[postData appendData:[[NSString stringWithFormat:@"--%@\r\n",myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:[parameterValue dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	NSString * postLength = [NSString stringWithFormat:@"%lu",postData.length];
	[urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[urlRequest setHTTPBody:postData];
	
	return urlRequest;
}

@end

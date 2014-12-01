
#import <Foundation/Foundation.h>

@interface NSURLRequest (GWAdditions)
+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host;

//Returns an NSURLRequest prepared for an HTTP file upload using standard
//multipart/form POST data. http://www.cocoadev.com/index.pl?HTTPFileUpload
+ (NSURLRequest *) fileUploadRequestWithURL:(NSString *) url data:(NSData *) data fileName:(NSString *) fileName variables:(NSDictionary *) variables;

@end


#import <Foundation/Foundation.h>

@interface NSString (GWAdditions)

+ (NSString *) UTF8StringWithDataAndLatin1MacOSFallbacks:(NSData *) data;
- (NSString *) stringByTrimmingNewlines;
- (NSString *) stringByTrimmingNewlinesAndWhitespace;
- (NSString *) stringByTrimmingWhitespace;

@end

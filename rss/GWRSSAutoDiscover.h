
#import <Foundation/Foundation.h>
#import "GWRegex.h"
#import "NSString+GWAdditions.h"

#pragma mark forwards

@class GWRSSAutoDiscoverResponse;

#pragma mark typedefs

/* completion block for responses */
typedef void (^GWRSSAutoDiscoverCompletion)(GWRSSAutoDiscoverResponse * response);

#pragma mark GWRSSAutoDiscover

/* RSS Auto Discover Object. */
@interface GWRSSAutoDiscover : NSObject
- (GWRSSAutoDiscoverResponse *) discoverRSSForURL:(NSURL *) url completion:(GWRSSAutoDiscoverCompletion) completion;
@end

#pragma mark GWWRSSAutoDiscoverResponse

/* RSS auto discover response object - used for synchronous and asynchronous results. */
@interface GWRSSAutoDiscoverResponse : NSObject

//the rss URL.
@property NSURL * rss;

//the original URL passed to [GWRSSAutoDiscover discoverRSSForURL:completion:].
@property NSURL * requestURL;

//if != NULL, an error occured.
@property NSError * error;

//response is always the NSURLConnection response whether successful or not.
@property NSURLResponse * response;
@end


#import <Foundation/Foundation.h>
#import "NSDate+InternetDateTime.h"
#import "NSString+GWAdditions.h"

#pragma mark forwards

@class GWRSSItem;
@class GWRSSEnclosure;
@class GWRSSImage;
@class GWRSSResponse;

#pragma mark typedefs

typedef void (^GWRSSResponseBlock)(GWRSSResponse * response);

typedef enum GWRSSFeedType {
	GWRSSFeedTypeUnknown = 1,
	GWRSSFeedTypeRSS,
	GWRSSFeedTypeRSS1RDF,
	GWRSSFeedTypeAtom,
} GWRSSFeedType;

#pragma mark GWRSS

@interface GWRSS : NSObject <NSXMLParserDelegate>
@property GWRSSFeedType feedType;
@property GWRSSImage * image;
@property NSURL * url;
@property NSURL * link;
@property NSString * title;
@property NSString * summary;
@property NSArray * items;
- (GWRSSResponse *) parseFeedAtURL:(NSURL *) url completion:(GWRSSResponseBlock) completion;
- (GWRSSResponse *) parseData:(NSData *)data;
- (void) logFeed;
@end

#pragma mark GWRSSItem

@interface GWRSSItem : NSObject
@property NSDate * created;
@property NSDate * updated;
@property NSURL * link;
@property NSString * guid;
@property NSString * identifier;
@property NSString * author;
@property NSString * title;
@property NSString * summary;
@property NSString * content;
@property GWRSSImage * image;
@property GWRSSEnclosure * enclosure;
@end

#pragma mark GWRSSEnclosure

@interface GWRSSEnclosure : NSObject
@property NSString * type;
@property NSURL * url;
@property NSNumber * length;
@end

#pragma mark GWRSSImage

@interface GWRSSImage : NSObject
@property NSURL * link;
@property NSURL * url;
@property NSString * title;
@property NSString * summary;
@property NSNumber * width;
@property NSNumber * height;
@end

#pragma mark GWRSSResponse

@interface GWRSSResponse : NSObject
@property NSError * error;
@property NSURLResponse * connectionResponse;
@end

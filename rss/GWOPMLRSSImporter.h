
#import <Foundation/Foundation.h>
#import "GWRegex.h"
#import "GWOPMLRSSFeedRecord.h"

@interface GWOPMLRSSImporter : NSObject <NSXMLParserDelegate>
- (NSArray *) feedsForData:(NSData *) data;
- (NSArray *) feedsForOPMLFileAtURL:(NSURL *) url;
@end

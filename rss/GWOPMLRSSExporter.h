
#import <Foundation/Foundation.h>
#import "GWOPMLRSSFeedRecord.h"

@interface GWOPMLRSSExporter : NSObject
- (id) initWithURL:(NSURL *) url;
- (void) startWriting;
- (void) finishWriting;
- (void) writeRecords:(NSArray *) records;
- (void) writeRecord:(GWOPMLRSSFeedRecord *) record;
@end

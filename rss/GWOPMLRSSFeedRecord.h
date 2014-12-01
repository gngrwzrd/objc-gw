
#import <Foundation/Foundation.h>

@interface GWOPMLRSSFeedRecord : NSObject
@property BOOL isGroup;
@property NSString * groupName;
@property NSArray * groupRecords;
@property NSURL * htmlURL;
@property NSURL * xmlURL;
@property NSString * text;
@property NSString * title;
@property NSString * summary;

+ (GWOPMLRSSFeedRecord *) opmlGroupRecordForName:(NSString *) name;
+ (GWOPMLRSSFeedRecord *) opmlRecordWithHTMLURL:(NSURL *) htmlurl xmlURL:(NSURL *) xmlurl text:(NSString *) text title:(NSString *) title summary:(NSString *) summary;
- (void) addRecord:(GWOPMLRSSFeedRecord *) record;

@end


#import "GWOPMLRSSFeedRecord.h"

@interface GWOPMLRSSFeedRecord () {
	NSMutableArray * _groupRecords;
}

@end

@implementation GWOPMLRSSFeedRecord

- (id) _initGroup {
	self = [super init];
	_isGroup = TRUE;
	_groupRecords = [[NSMutableArray alloc] init];
	return self;
}

+ (GWOPMLRSSFeedRecord *) opmlGroupRecordForName:(NSString *) name; {
	GWOPMLRSSFeedRecord * record = [[GWOPMLRSSFeedRecord alloc] _initGroup];
	record.isGroup = TRUE;
	record.groupName = name;
	return record;
}

+ (GWOPMLRSSFeedRecord *) opmlRecordWithHTMLURL:(NSURL *) htmlurl xmlURL:(NSURL *) xmlurl text:(NSString *) text title:(NSString *) title summary:(NSString *) summary; {
	GWOPMLRSSFeedRecord * record = [[GWOPMLRSSFeedRecord alloc] init];
	record.htmlURL = htmlurl;
	record.xmlURL = xmlurl;
	record.text = text;
	record.title = title;
	record.summary = summary;
	return record;
}

- (void) addRecord:(GWOPMLRSSFeedRecord *)record {
	if(!_isGroup) {
		return;
	}
	[_groupRecords addObject:record];
}

@end

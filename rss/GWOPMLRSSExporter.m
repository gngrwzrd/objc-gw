
#import "GWOPMLRSSExporter.h"

@interface GWOPMLRSSExporter () {
	BOOL _opened;
	NSURL * _url;
	NSOutputStream * _outputStream;
}
@end

@implementation GWOPMLRSSExporter

- (id) init {
	self = [super init];
	_outputStream = [NSOutputStream outputStreamToMemory];
	return self;
}

- (id) initWithURL:(NSURL *) url; {
	self = [super init];
	_outputStream = [NSOutputStream outputStreamWithURL:url append:FALSE];
	return self;
}

- (void) _writeStrings:(NSArray *) strings {
	for(NSString * string in strings) {
		[_outputStream write:(const uint8_t *)[string UTF8String] maxLength:string.length];
	}
}

- (void) startWriting {
	if(!_opened) {
		[_outputStream open];
	}
	NSArray * strings = @[
		@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
		@"<opml>\n",
		@"<head>\n",
		@"<title>My Subscriptions</title>\n",
		@"</head>\n",
		@"<body>\n",
	];
	[self _writeStrings:strings];
}

- (void) finishWriting {
	NSArray * strings = @[
		@"</body>\n",
		@"</opml>"
	];
	[self _writeStrings:strings];
	[_outputStream close];
}

- (void) writeRecords:(NSArray *) records {
	for(GWOPMLRSSFeedRecord * record in records) {
		[self writeRecord:record];
	}
}

- (void) writeRecord:(GWOPMLRSSFeedRecord *) record {
	if(record.isGroup) {
		[self _writeStrings:@[[NSString stringWithFormat:@"\t<outline text=\"%@\" title=\"%@\">\n",record.groupName,record.groupName]]];
		[self writeRecords:record.groupRecords];
		[self _writeStrings:@[@"\t</outline>\n"]];
	} else {
		NSString * string = [NSString
			stringWithFormat:@"\t<outline text=\"%@\" description=\"%@\" title=\"%@\" type=\"rss\" version=\"RSS\" htmlURL=\"%@\" xmlURL=\"%@\" />\n",
			record.text,record.summary,record.title,record.htmlURL,record.xmlURL
		];
		NSArray * strings = @[string];
		[self _writeStrings:strings];
	}
}

@end

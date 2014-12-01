
#import "GWOPMLRSSImporter.h"

@interface GWOPMLRSSImporter () {
	NSXMLParser * _parser;
	NSError * _error;
	NSString * _path;
	NSDictionary * _attributes;
	NSMutableString * _elementText;
	GWOPMLRSSFeedRecord * _record;
	NSMutableArray * _records;
}
@end

@implementation GWOPMLRSSImporter

- (id) init {
	self = [super init];
	_path = [NSMutableString stringWithString:@"/"];
	_records = [NSMutableArray array];
	return self;
}

- (NSArray *) feedsForData:(NSData *)data {
	return NULL;
}

- (NSArray *) feedsForOPMLFileAtURL:(NSURL *)url {
	return NULL;
}

- (void) _parseData:(NSData *) data {
	_parser = [[NSXMLParser alloc] initWithData:data];
	_parser.delegate = self;
	[_parser parse];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	_path = [_path stringByAppendingPathComponent:elementName];
	_attributes = attributeDict;
	
	if([_path isEqualToString:@"/opml/body/outline"]) {
		_record = [[GWOPMLRSSFeedRecord alloc] init];
	}
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSString * _tmpPath = [_path copy];
	_path = [_path stringByDeletingLastPathComponent];
	
	if([_tmpPath isEqualToString:@"/opml/body/outline"]) {
		_record.title = [_attributes objectForKey:@"title"];
		_record.summary = [_attributes objectForKey:@"description"];
		_record.text = [_attributes objectForKey:@"text"];
	}
	
	if([_tmpPath regexMatches:@"[/outline]+$"].count > 0) {
		
	}
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	NSString * string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
	[_elementText appendString:string];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[_elementText appendString:string];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	_error = parseError;
}

- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
	_error = validationError;
}

@end

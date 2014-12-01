
#import "GWRSS.h"

@interface GWRSS () {
	NSMutableArray * _items;
	NSXMLParser * _parser;
	NSData * _feedData;
	NSMutableString * _elementText;
	NSString * _currentPath;
	NSDictionary * _elementAttribs;
	NSError * _error;
	GWRSSImage * _feedImage;
	GWRSSItem * _item;
}
@end

@implementation GWRSS

- (id) init {
	self = [super init];
	_items = [NSMutableArray array];
	_currentPath = @"/";
	self.feedType = GWRSSFeedTypeUnknown;
	return self;
}

- (GWRSSResponse *) parseFeedAtURL:(NSURL *) url completion:(GWRSSResponseBlock) completion; {
	self.url = url;
	if(!completion) {
		return [self _parseFeedAtURLSynchronous:url];
	} else {
		return [self _parseFeedAtURLAsynch:url completion:completion];
	}
	return nil;
}

- (GWRSSResponse *) parseData:(NSData *)data; {
	GWRSSResponse * response = [[GWRSSResponse alloc] init];
	[self _parseData:data];
	if(_error) {
		response.error = _error;
		return response;
	}
	return response;
}

- (GWRSSResponse *) _parseFeedAtURLSynchronous:(NSURL *)url; {
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSURLResponse * __autoreleasing conresponse = NULL;
	NSError * __autoreleasing conerror = NULL;
	GWRSSResponse * response = [[GWRSSResponse alloc] init];
	NSData * feedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&conresponse error:&conerror];
	response.connectionResponse = conresponse;
	if(conerror) {
		response.error = conerror;
		return response;
	}
	[self _parseData:feedData];
	if(_error) {
		response.error = _error;
		return response;
	}
	return response;
}

- (GWRSSResponse *) _parseFeedAtURLAsynch:(NSURL *) url completion:(GWRSSResponseBlock) completion; {
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		GWRSSResponse * rssresponse = [[GWRSSResponse alloc] init];
		rssresponse.connectionResponse = response;
		if(connectionError) {
			rssresponse.error = connectionError;
		} else {
			[self _parseData:data];
			if(_error) {
				rssresponse.error = _error;
			}
		}
		completion(rssresponse);
	}];
	return nil;
}

- (void) _parseData:(NSData *) data {
	_parser = [[NSXMLParser alloc] initWithData:data];
	_parser.delegate = self;
	[_parser parse];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	//update curent tree path
	_currentPath = [_currentPath stringByAppendingPathComponent:elementName];
	//NSLog(@"%@",_currentPath);
	
	//save for didEndElement:
	_elementAttribs = attributeDict;
	
	//determine feed type
	if(self.feedType == GWRSSFeedTypeUnknown) {
		if([_currentPath isEqualToString:@"/feed"]) {
			self.feedType = GWRSSFeedTypeAtom;
		} else if([_currentPath isEqualToString:@"/rss"]) {
			self.feedType = GWRSSFeedTypeRSS;
		} else if([_currentPath isEqualToString:@"/rdf:RDF"]) {
			self.feedType = GWRSSFeedTypeRSS1RDF;
		}
	}
	
	//start new element text
	_elementText = [[NSMutableString alloc] init];
	
	//determine if a new GWRSSItem should be started.
	BOOL startItem = FALSE;
	
	//atom
	if([_currentPath isEqualToString:@"/feed/entry"]) {
		startItem = TRUE;
	}
	
	//rss1
	else if([_currentPath isEqualToString:@"/rdf:RDF/item"]) {
		startItem = TRUE;
	}
	
	//rss2
	else if([_currentPath isEqualToString:@"/rss/channel/item"]) {
		startItem = TRUE;
	}
	
	//start a new rss item if necessary
	if(startItem) {
		_item = [[GWRSSItem alloc] init];
	}
	
	//start a new image
	if([_currentPath isEqualToString:@"/rss/channel/image"]) {
		_feedImage = [[GWRSSImage alloc] init];
	}
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//save current path, go up one level with _currentPath
	NSString * _tmpPath = [_currentPath copy];
	_currentPath = [_currentPath stringByDeletingLastPathComponent];
	
	//no item yet, parsing feed info
	if(!_item) {
		
		//check for RSS 0.9 - 2.0 feed info
		if([_tmpPath isEqualToString:@"/rss/channel/title"]) {
			self.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/link"]) {
			self.link = [NSURL URLWithString:[_elementText stringByTrimmingNewlinesAndWhitespace]];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/description"]) {
			self.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/image/title"]) {
			_feedImage.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/image/url"]) {
			_feedImage.url = [NSURL URLWithString:[_elementText stringByTrimmingNewlinesAndWhitespace]];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/image/description"]) {
			_feedImage.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/image/width"]) {
			_feedImage.width = [NSNumber numberWithInteger:[_elementText stringByTrimmingNewlinesAndWhitespace].integerValue];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/image/height"]) {
			_feedImage.height = [NSNumber numberWithInteger:[_elementText stringByTrimmingNewlinesAndWhitespace].integerValue];
			return;
		} else if([_tmpPath isEqualToString:@"/rss/channel/image"]) {
			self.image = _feedImage;
			_feedImage = NULL;
			return;
		}
		
		//check for RSS1 feed info
		if([_tmpPath isEqualToString:@"/rdf:RDF/channel/title"]) {
			self.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/channel/link"]) {
			self.link = [NSURL URLWithString:[_elementText stringByTrimmingNewlinesAndWhitespace]];
			return;
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/channel/description"]) {
			self.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		}
		
		//check for ATOM feed info
		if([_tmpPath isEqualToString:@"/feed/title"]) {
			self.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/feed/link"]) {
			NSURL * url = [self _createLinkWithAttributes:_elementAttribs forRSSType:self.feedType inFeedInfo:TRUE];
			if(url) {
				self.link = url;
			}
			return;
		} else if([_tmpPath isEqualToString:@"/feed/subtitle"]) {
			self.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		} else if([_tmpPath isEqualToString:@"/feed/description"]) {
			self.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
			return;
		}
	}
	
	//figure out if item should end
	BOOL endItem = FALSE;
	if([_tmpPath isEqualToString:@"/feed/entry"]) {
		endItem = TRUE;
	} else if([_tmpPath isEqualToString:@"/rss/channel/item"]) {
		endItem = TRUE;
	} else if([_tmpPath isEqualToString:@"/rdf:RDF/item"]) {
		endItem = TRUE;
	}
	
	//end item if necessary
	if(endItem) {
		[_items addObject:_item];
		_item = NULL;
		_elementText = NULL;
		return;
	}
	
	//check for RSS 0.9 - 2.0 entries
	if(self.feedType == GWRSSFeedTypeRSS) {
		if([_tmpPath isEqualToString:@"/rss/channel/item/title"]) {
			_item.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/link"]) {
			_item.link = [NSURL URLWithString:[_elementText stringByTrimmingNewlinesAndWhitespace]];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/author"]) {
			_item.author = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/dc:creator"]) {
			_item.author = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/description"]) {
			_item.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/pubDate"]) {
			_item.created = [NSDate dateFromInternetDateTimeString:[_elementText stringByTrimmingNewlinesAndWhitespace] formatHint:DateFormatHintNone];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/enclosure"]) {
			_item.enclosure = [self _createEnclosureWithAttributes:_elementAttribs forRSSType:self.feedType];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/guid"]) {
			_item.guid = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/dc:creator"]) {
			_item.author = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/dc:date"]) {
			_item.created = [NSDate dateFromInternetDateTimeString:[_elementText stringByTrimmingNewlinesAndWhitespace] formatHint:DateFormatHintNone];
		} else if([_tmpPath isEqualToString:@"/rss/channel/item/content:encoded"]) {
			_item.content = [_elementText stringByTrimmingNewlinesAndWhitespace];
		}
		return;
	}
	
	//RSS1 RDF
	if(self.feedType == GWRSSFeedTypeRSS1RDF) {
		if([_tmpPath isEqualToString:@"/rdf:RDF/item/title"]) {
			_item.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/link"]) {
			_item.link = [NSURL URLWithString:[_elementText stringByTrimmingNewlinesAndWhitespace]];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/description"]) {
			_item.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/image"]) {
			_item.image = [self _createImageWithAttributes:_elementAttribs forRSSType:self.feedType];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/content:encoded"]) {
			_item.content = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/dc:date"]) {
			_item.created = [NSDate dateFromInternetDateTimeString:[_elementText stringByTrimmingNewlinesAndWhitespace] formatHint:DateFormatHintNone];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/dc:creator"]) {
			_item.author = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/dc:date"]) {
			_item.created = [NSDate dateFromInternetDateTimeString:[_elementText stringByTrimmingNewlinesAndWhitespace] formatHint:DateFormatHintNone];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/dc:identifier"]) {
			_item.guid = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/rdf:RDF/item/enc:enclosure"]) {
			_item.enclosure = [self _createEnclosureWithAttributes:_elementAttribs forRSSType:self.feedType];
		}
		return;
	}
	
	//ATOM
	if(self.feedType == GWRSSFeedTypeAtom) {
		if([_tmpPath isEqualToString:@"/feed/entry/title"]) {
			_item.title = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/feed/entry/link"]) {
			NSString * rel = [_elementAttribs objectForKey:@"rel"];
			if(!rel || [rel isEqualToString:@"alternate"]) {
				_item.link = [NSURL URLWithString:[_elementAttribs objectForKey:@"href"]];
			} else if([rel isEqualToString:@"enclosure"]) {
				_item.enclosure = [self _createEnclosureWithAttributes:_elementAttribs forRSSType:self.feedType];
			}
		} else if([_tmpPath isEqualToString:@"/feed/entry/summary"]) {
			_item.summary = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/feed/entry/content"]) {
			_item.content = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/feed/entry/author/name"]) {
			_item.author = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/feed/entry/dc:creator"]) {
			_item.author = [_elementText stringByTrimmingNewlinesAndWhitespace];
		} else if([_tmpPath isEqualToString:@"/feed/entry/published"]) {
			_item.created = [NSDate dateFromInternetDateTimeString:[_elementText stringByTrimmingNewlinesAndWhitespace] formatHint:DateFormatHintNone];
		} else if([_tmpPath isEqualToString:@"/feed/entry/updated"]) {
			_item.updated = [NSDate dateFromInternetDateTimeString:[_elementText stringByTrimmingNewlinesAndWhitespace] formatHint:DateFormatHintNone];
		}
	}
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[_elementText appendString:string];
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	NSString * s = [NSString UTF8StringWithDataAndLatin1MacOSFallbacks:CDATABlock];
	[_elementText appendString:s];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	_error = parseError;
}

- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
	_error = validationError;
}

- (NSURL *) _createLinkWithAttributes:(NSDictionary *) dict forRSSType:(GWRSSFeedType) type inFeedInfo:(BOOL) inFeedInfo; {
	NSURL * url = NULL;
	if(inFeedInfo) {
		if(type == GWRSSFeedTypeRSS || type == GWRSSFeedTypeAtom) {
			NSString * rel = [_elementAttribs objectForKey:@"rel"];
			if(!rel || [rel isEqualToString:@"alternate"]) {
				NSString * href = [[_elementAttribs objectForKey:@"href"] stringByTrimmingNewlinesAndWhitespace];
				url = [NSURL URLWithString:href];
			}
		}
	}
	return url;
}

- (GWRSSEnclosure *) _createEnclosureWithAttributes:(NSDictionary *) dict forRSSType:(GWRSSFeedType) type; {
	GWRSSEnclosure * enclosure = [[GWRSSEnclosure alloc] init];
	if(type == GWRSSFeedTypeRSS) {
		enclosure.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
		enclosure.length = [NSNumber numberWithInteger:[[dict objectForKey:@"length"] integerValue]];
		enclosure.type = [dict objectForKey:@"type"];
	} else if(type == GWRSSFeedTypeAtom) {
		enclosure.url = [NSURL URLWithString:[dict objectForKey:@"href"]];
		enclosure.length = [NSNumber numberWithInteger:[[dict objectForKey:@"length"] integerValue]];
		enclosure.type = [dict objectForKey:@"type"];
	} else if(type == GWRSSFeedTypeRSS1RDF) {
		enclosure.url = [NSURL URLWithString:[dict objectForKey:@"rdf:resource"]];
		enclosure.length = [NSNumber numberWithInteger:[[dict objectForKey:@"enc:length"] integerValue]];
		enclosure.type = [dict objectForKey:@"enc:type"];
	}
	return enclosure;
}

- (GWRSSImage *) _createImageWithAttributes:(NSDictionary *) dict forRSSType:(GWRSSFeedType) type {
	GWRSSImage * image = [[GWRSSImage alloc] init];
	if(type == GWRSSFeedTypeRSS1RDF) {
		NSURL * url = [NSURL URLWithString:[[dict objectForKey:@"rdf:resource"] stringByTrimmingNewlinesAndWhitespace]];
		image.url = url;
	}
	return image;
}

- (void) logFeed {
	NSLog(@"--feed info--");
	NSLog(@"feed title: %@",self.title);
	NSLog(@"feed link: %@",self.link);
	NSLog(@"feed summary: %@", self.summary);
	
	if(self.image) {
		NSLog(@"--feed image--");
		NSLog(@"feed image title: %@",self.image.title);
		NSLog(@"feed image summary: %@",self.image.summary);
		NSLog(@"feed image url: %@",self.image.url);
		NSLog(@"feed image dimensions: %li %li", self.image.width.integerValue, self.image.height.integerValue);
	}
	
	if(_items.count > 0) {
		NSLog(@"--feed items--");
		for(GWRSSItem * item in _items) {
			NSLog(@"%@",item);
		}
	}
}

@end

@implementation GWRSSItem
- (NSString *) description {
	NSString * __title = self.title;
	if(__title.length > 10) {
		__title = [[self.title substringWithRange:NSMakeRange(0,10)] stringByAppendingString:@"..."];
	}
	NSMutableString * des = [NSMutableString string];
	[des appendFormat:@"\ncreated:%@",self.created];
	[des appendFormat:@"\nupdated:%@",self.updated];
	[des appendFormat:@"\nlink:%@",self.link];
	[des appendFormat:@"\nguid:%@",self.guid];
	[des appendFormat:@"\nidentifier:%@",self.identifier];
	[des appendFormat:@"\nauthor:%@",self.author];
	[des appendFormat:@"\ntitle:%@",self.title];
	[des appendFormat:@"\nsummary:%@",self.summary];
	[des appendFormat:@"\ncontent:%@",self.content];
	[des appendString:@"\n\n"];
	return des;
}
@end

@implementation GWRSSImage
@end

@implementation GWRSSEnclosure
@end

@implementation GWRSSResponse
@end

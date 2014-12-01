
#import "GWRSSAutoDiscover.h"

@implementation GWRSSAutoDiscover

- (GWRSSAutoDiscoverResponse *) discoverRSSForURL:(NSURL *) url completion:(GWRSSAutoDiscoverCompletion) completion {
	if(!completion) {
		return [self _sendSynchronousRequestForURL:url];
	} else {
		return [self _sendAsynchronousRequestForURL:url completion:completion];
	}
	return NULL;
}

- (GWRSSAutoDiscoverResponse *) _sendSynchronousRequestForURL:(NSURL *) url {
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSURLResponse * response = NULL;
	NSError * error = NULL;
	NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	GWRSSAutoDiscoverResponse * res = [[GWRSSAutoDiscoverResponse alloc] init];
	res.requestURL = url;
	res.response = response;
	if(error) {
		res.error = error;
		return res;
	}
	res.rss = [self extractRSS:data withURL:url];
	return res;
}

- (GWRSSAutoDiscoverResponse *) _sendAsynchronousRequestForURL:(NSURL *) url completion:(GWRSSAutoDiscoverCompletion) completion {
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		GWRSSAutoDiscoverResponse * res = [[GWRSSAutoDiscoverResponse alloc] init];
		res.response = response;
		res.requestURL = url;
		if(connectionError) {
			res.error = connectionError;
		} else {
			res.rss = [self extractRSS:data withURL:url];
		}
		completion(res);
	}];
	return NULL;
}

- (NSURL *) extractRSS:(NSData *) data withURL:(NSURL *) url {
	//convert data to NSString
	NSString * content = [NSString UTF8StringWithDataAndLatin1MacOSFallbacks:data];
	if(!content) {
		NSLog(@"Error converting url data to usable string format");
		return NULL;
	}
	
	//trim page content of newlines
	NSString * trimmedContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	//extract <link> tags from headContent
	NSString * linksRegex = @"link[ a-zA-Z0-9\\+\\*\\#\\!\\$\\;\\_\\@\\~\\/\\'\"\\?\\&\\:\\/\\=\\.\\-]*\\/?['|\"]";
	NSArray * links = [trimmedContent regexMatches:linksRegex];
	
	//check each found link from linksRegexer by trimming it and looking for rel=alternate and type=application/rss+xml
	NSString * trimmed = NULL;
	NSString * link = NULL;
	for(NSArray * linkMatch in links) {
		link = ((GWRegexMatch *)[linkMatch objectAtIndex:0]).match;
		trimmed = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if([trimmed regexContains:@"rel=['\"]alternate['\"]"] && [trimmed regexContains:@"type=['\"]application/rss\\+xml['\"]"]) {
			break;
		}
	}
	
	//extract the href out of the rss link
	NSString * rssurlRegex = @"href=['|\"]([a-zA-Z0-9\\+\\*\\#\\!\\$\\;\\_\\@\\~\\/\\'\"\\?\\&\\:\\/\\=\\.\\-]*)['|\"]";
	NSArray * hrefMatches = [trimmed regexMatches:rssurlRegex];
	if(hrefMatches.count < 1) {
		return NULL;
	}
	
	//build the final url and make sure to include domain/protocol in the absolute path.
	NSString * rssurlstr = ((GWRegexMatch *)[[hrefMatches objectAtIndex:0] objectAtIndex:1]).match;
	NSRange proto = [rssurlstr rangeOfString:@"http"];
	NSURL * rssurl = NULL;
	if(proto.location == LONG_MAX) {
		rssurl = [url URLByAppendingPathComponent:rssurlstr];
	} else {
		rssurl = [NSURL URLWithString:rssurlstr];
	}
	
	return rssurl;
}

@end

@implementation GWRSSAutoDiscoverResponse
@end

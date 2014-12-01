
#import "GWRegex.h"

#pragma mark GWRegex

@implementation GWRegex

+ (NSArray *) _resultsForRegex:(regex_t *) regex matches:(regmatch_t *) matches search:(const char *) search; {
	NSMutableArray * results = [NSMutableArray array];
	char buf[GWRegexBufSize];
	const char * match_start = NULL;
	const char * csearch = search;
	size_t len = 0;
	size_t nsubs = regex->re_nsub+1;
	GWRegexMatch * match = [[GWRegexMatch alloc] init];
	for(int i = 0; i < nsubs; i++) {
		bzero(buf,sizeof(buf));
		len = matches[i].rm_eo-matches[i].rm_so;
		match_start = &csearch[matches[i].rm_so];
		strncpy(buf,match_start,len);
		NSString * matchstr = [NSString stringWithUTF8String:buf];
		match = [[GWRegexMatch alloc] init];
		match.start = matches[i].rm_so;
		match.end = matches[i].rm_eo;
		match.match = matchstr;
		[results addObject:match];
	}
	return results;
}

+ (int) _executeRegex:(regex_t *) regex matches:(regmatch_t *) matches search:(const char *) search eflags:(int) eflags passes:(int) passes {
	int error = regexec(regex,search,regex->re_nsub+1,matches,eflags);
	char buf[GWRegexBufSize];
	if(error != 0 && passes < 1) {
		if(error != 1) {
			bzero(buf,sizeof(buf));
			regerror(error,regex,buf,sizeof(buf));
			NSLog(@"regexec error (%s)",buf);
		}
		return error;
	} else if(error != 0 && passes > 0) {
		return -1;
	}
	return 0;
}

+ (NSArray *) _search:(NSString *) search expression:(NSString *) expression regex:(regex_t *) regex eflags:(int) eflags; {
	int error = 0;
	int passes = 0;
	const char * csearch = [search UTF8String];
	size_t nsubs = regex->re_nsub+1;
	regmatch_t * regmatches = calloc(nsubs,sizeof(regmatch_t));
	NSArray * results = NULL;
	NSMutableArray * allMatches = [NSMutableArray array];
	while(error == 0) {
		error = [GWRegex _executeRegex:regex matches:regmatches search:csearch eflags:eflags passes:passes];
		if(error != 0) {
			break;
		}
		results = [GWRegex _resultsForRegex:regex matches:regmatches search:csearch];
		csearch = (&csearch[regmatches[0].rm_so])+(regmatches[0].rm_eo-regmatches[0].rm_so);
		[allMatches addObject:results];
		passes++;
	}
	free(regmatches);
	return allMatches;
}

+ (NSArray *) search:(NSString *) search expression:(NSString *) expression; {
	return [GWRegex search:search expression:expression cflags:REG_EXTENDED eflags:0];
}

+ (NSArray *) search:(NSString *) search expression:(NSString *) expression cflags:(int) cflags eflags:(int) eflags; {
	int error = 0;
	char buf[GWRegexBufSize];
	regex_t _regex;
	error = regcomp(&_regex,[expression UTF8String],cflags);
	if(error != 0) {
		bzero(buf,sizeof(buf));
		regerror(error,&_regex,buf,sizeof(buf));
		NSLog(@"regcomp error (%s) for expression: %@",buf,expression);
		return NULL;
	}
	return [GWRegex _search:search expression:expression regex:&_regex eflags:eflags];
}

+ (BOOL) contains:(NSString *) expression search:(NSString *) search; {
	return [GWRegex contains:expression search:search cflags:REG_EXTENDED eflags:0];
}

+ (BOOL) contains:(NSString *) expression search:(NSString *) search cflags:(int) cflags eflags:(int) eflags; {
	NSArray * results = [GWRegex search:search expression:expression cflags:cflags eflags:eflags];
	if(results && results.count > 0) {
		return TRUE;
	}
	return FALSE;
}

- (id) initWithRegex:(NSString *) expression; {
	return [self initWithRegex:expression cflags:REG_EXTENDED];
}

- (id) initWithRegex:(NSString *) expression cflags:(int) cflags; {
	self = [self init];
	_expression = expression;
	const char * cexpression = [expression UTF8String];
	int error = regcomp(&_regex,cexpression,cflags);
	if(error != 0) {
		bzero(_buf,sizeof(_buf));
		regerror(error,&_regex,_buf,sizeof(_buf));
		NSLog(@"regcomp error (%s) for expression: %@",_buf,expression);
		regfree(&_regex);
		return NULL;
	}
	return self;
}

- (NSArray *) execute:(NSString *) search; {
	return [self execute:search eflags:0];
}

- (NSArray *) execute:(NSString *) search eflags:(int) eflags; {
	return [GWRegex _search:search expression:_expression regex:&_regex eflags:eflags];
}

- (BOOL) containsMatches:(NSString *) search; {
	return [self containsMatches:search eflags:0];
}

- (BOOL) containsMatches:(NSString *) search eflags:(int) eflags; {
	NSArray * matches = [self execute:search eflags:eflags];
	if(matches && matches.count > 0) {
		return TRUE;
	}
	return FALSE;
}

- (void) dealloc {
	regfree(&_regex);
}

@end


#pragma mark GWRegexMatch

@implementation GWRegexMatch

- (NSString *) description {
	return [NSString stringWithFormat:@"%lu-%lu:%@",self.start,self.end,self.match];
}

@end


#pragma mark NSString Addition

@implementation NSString (GWRegex)

- (NSArray *) regexMatches:(NSString *) expression; {
	return [GWRegex search:self	expression:expression];
}

- (NSArray *) regexMatches:(NSString *) expression cflags:(int) cflags eflags:(int) eflags; {
	return [GWRegex search:self expression:expression cflags:cflags eflags:eflags];
}

- (BOOL) regexContains:(NSString *) expression; {
	return [GWRegex contains:expression search:self];
}

- (BOOL) regexContains:(NSString *) expression cflags:(int) cflags eflags:(int) eflags; {
	return [GWRegex contains:expression search:self cflags:cflags eflags:eflags];
}

@end

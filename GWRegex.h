
#import <Foundation/Foundation.h>
#include <regex.h>

#define GWRegexBufSize 512

#pragma mark NSString addition
@interface NSString (GWRegex)
- (NSArray *) regexMatches:(NSString *) expression;
- (NSArray *) regexMatches:(NSString *) expression cflags:(int) cflags eflags:(int) eflags;
- (BOOL) regexContains:(NSString *) expression;
- (BOOL) regexContains:(NSString *) expression cflags:(int) cflags eflags:(int) eflags;
@end

#pragma mark GWRegex

//simple regex.h wrapper to simplify the c functions.
@interface GWRegex : NSObject {
	regex_t _regex;
	char _buf[GWRegexBufSize];
}

@property NSString * expression;
+ (NSArray *) search:(NSString *) search expression:(NSString *) expression;
+ (NSArray *) search:(NSString *) search expression:(NSString *) expression cflags:(int) cflags eflags:(int) eflags;
+ (BOOL) contains:(NSString *) expression search:(NSString *) search;
+ (BOOL) contains:(NSString *) expression search:(NSString *) search cflags:(int) cflags eflags:(int) eflags;
- (id) initWithRegex:(NSString *) expression;
- (id) initWithRegex:(NSString *) expression cflags:(int) cflags;
- (NSArray *) execute:(NSString *) search;
- (NSArray *) execute:(NSString *) search eflags:(int) eflags;
- (BOOL) containsMatches:(NSString *) search;
- (BOOL) containsMatches:(NSString *) search eflags:(int) eflags;
@end

#pragma mark GWRegexMatch

//match object
@interface GWRegexMatch : NSObject
@property NSUInteger start; //start index
@property NSUInteger end;   //end index
@property NSString * match; //match string
@end

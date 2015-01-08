
#import <Foundation/Foundation.h>

@interface NSURL (Additions)

+ (NSString *) relativizeFileSystemPathTo:(NSURL *) to fromPath:(NSURL *) from;
- (NSString *) relativizeFileSystemPathFrom:(NSURL *) fromURL;
- (NSString *) relativizeFileSystemPathTo:(NSURL *) toURL;

+ (NSURL *) secureHTTPURLWithString:(NSString *) string;

@end

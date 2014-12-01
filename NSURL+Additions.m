
#import "NSURL+Additions.h"

NSString * relativize(NSURL * to, NSURL * from) {
	BOOL fromIsDir = false;
	NSFileManager * fileManager = [NSFileManager defaultManager];
	[fileManager fileExistsAtPath:from.path isDirectory:&fromIsDir];
	
	NSString * toString = [[to absoluteString] stringByStandardizingPath];
	NSMutableArray * toPieces = [NSMutableArray arrayWithArray:[toString pathComponents]];
	
	NSString * fromString = [[from absoluteString] stringByStandardizingPath];
	NSMutableArray * fromPieces = [NSMutableArray arrayWithArray:[fromString pathComponents]];
	
	NSMutableString * relPath = [NSMutableString string];
	
	NSString * toTrimmed = toString;
	NSString * toPiece = NULL;
	NSString * fromTrimmed = fromString;
	NSString * fromPiece = NULL;
	
	NSMutableArray * parents = [NSMutableArray array];
	NSMutableArray * pieces = [NSMutableArray array];
	
	if(toPieces.count >= fromPieces.count) {
		NSUInteger toCount = toPieces.count;
		while(toCount > fromPieces.count) {
			toPiece = [toTrimmed lastPathComponent];
			toTrimmed = [toTrimmed stringByDeletingLastPathComponent];
			[pieces insertObject:toPiece atIndex:0];
			toCount--;
		}
		
		while(![fromTrimmed isEqualToString:toTrimmed]) {
			toPiece = [toTrimmed lastPathComponent];
			toTrimmed = [toTrimmed stringByDeletingLastPathComponent];
			fromPiece = [fromTrimmed lastPathComponent];
			fromTrimmed = [fromTrimmed stringByDeletingLastPathComponent];
			if(![toPiece isEqualToString:fromPiece]) {
				if(![fromPiece isEqualToString:[fromPiece lastPathComponent]] || fromIsDir) {
					[parents addObject:@".."];
				}
				[pieces insertObject:toPiece atIndex:0];
			}
		}
		
	} else {
		NSUInteger fromCount = fromPieces.count;
		
		while(fromCount > toPieces.count) {
			fromPiece = [fromTrimmed lastPathComponent];
			fromTrimmed = [fromTrimmed stringByDeletingLastPathComponent];
			if(![fromPiece isEqualToString:[fromString lastPathComponent]] || fromIsDir) {
				[parents addObject:@".."];
			}
			fromCount--;
		}
		
		while(![toTrimmed isEqualToString:fromTrimmed]) {
			toPiece = [toTrimmed lastPathComponent];
			toTrimmed = [toTrimmed stringByDeletingLastPathComponent];
			fromPiece = [fromTrimmed lastPathComponent];
			fromTrimmed = [fromTrimmed stringByDeletingLastPathComponent];
			[parents addObject:@".."];
			[pieces insertObject:toPiece atIndex:0];
		}
		
	}
	
	[relPath appendString:[parents componentsJoinedByString:@"/"]];
	if(parents.count > 0) [relPath appendString:@"/"];
	else [relPath appendString:@"./"];
	[relPath appendString:[pieces componentsJoinedByString:@"/"]];
	
	NSLog(@"%@",relPath);
	
	return relPath;
}

@implementation NSURL (Additions)

+ (NSString *) relativizeFileSystemPathTo:(NSURL *) to fromPath:(NSURL *) from; {
	return relativize(to,from);
}

- (NSString *) relativizeFileSystemPathFrom:(NSURL *) fromURL; {
	return relativize(self,fromURL);
}

- (NSString *) relativizeFileSystemPathTo:(NSURL *) toURL; {
	return relativize(toURL,self);
}

@end

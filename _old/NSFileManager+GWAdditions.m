
#import "NSFileManager+GWAdditions.h"

@implementation NSFileManager (GWAdditions)

- (NSURL *) applicationSupportDirectoryURL {
	NSError * __autoreleasing error = NULL;
	NSURL * appSupport = [self URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:TRUE error:&error];
	if(error) {
		NSLog(@"Error getting application support directory: %@", error);
		return nil;
	}
	NSString * executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
	NSURL * fullPath = [appSupport URLByAppendingPathComponent:executableName];
	[self createDirectoryAtURL:fullPath withIntermediateDirectories:TRUE attributes:nil error:&error];
	if(error) {
		NSLog(@"Error creating application suppor directory: %@",error);
		return nil;
	}
	return fullPath;
}

@end

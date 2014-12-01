
#import "NSFileManager+GWAdditions.h"

@implementation NSFileManager (GWAdditions)

- (NSURL *) applicationSupportDirectoryURLWithExuecableName {
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

- (NSURL *) applicationSupportDirectoryURLWithBundleId; {
    NSError * __autoreleasing error = NULL;
    NSURL * appSupport = [self URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:TRUE error:&error];
    if(error) {
        NSLog(@"Error getting application support directory: %@", error);
        return nil;
    }
    NSString * bundleIdentifier = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
    NSURL * fullPath = [appSupport URLByAppendingPathComponent:bundleIdentifier];
    [self createDirectoryAtURL:fullPath withIntermediateDirectories:TRUE attributes:nil error:&error];
    if(error) {
        NSLog(@"Error creating application suppor directory: %@",error);
        return nil;
    }
    return fullPath;
}

- (NSURL *) applicationSupportDirectoryURLWithDirName:(NSString *) supportDirName; {
    NSError * __autoreleasing error = NULL;
    NSURL * appSupport = [self URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:TRUE error:&error];
    if(error) {
        NSLog(@"Error getting application support directory: %@", error);
        return nil;
    }
    NSURL * fullPath = [appSupport URLByAppendingPathComponent:supportDirName];
    [self createDirectoryAtURL:fullPath withIntermediateDirectories:TRUE attributes:nil error:&error];
    if(error) {
        NSLog(@"Error creating application suppor directory: %@",error);
        return nil;
    }
    return fullPath;
}

@end

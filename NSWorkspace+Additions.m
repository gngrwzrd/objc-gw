
#import "NSWorkspace+Additions.h"

@implementation NSWorkspace (Additions)

- (void) bringCurrentApplicationToFront {
	[self launchApplication:[[NSBundle mainBundle] bundlePath]];
}

- (void) uninstallStartupLaunchdItem:(NSURL *) plistURL; {
	NSFileManager * fm = [NSFileManager defaultManager];
	NSString * fileName = [plistURL lastPathComponent];
	NSString * file = [[@"~/Library/LaunchAgents" stringByExpandingTildeInPath] stringByAppendingPathComponent:fileName];
	[fm removeItemAtPath:file error:NULL];
}

- (void) installStartupLaunchdItem:(NSURL *) plistURL; {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
	NSNumber * perms = [NSNumber numberWithUnsignedLong:448]; //700 octal = 448 decimal
	[attrs setObject:perms forKey:NSFilePosixPermissions];
	NSString * targetPath = [@"~/Library/LaunchAgents/" stringByExpandingTildeInPath];
	NSString * destPath = [targetPath stringByAppendingPathComponent:[plistURL lastPathComponent]];
	[fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:TRUE attributes:attrs error:nil];
	[fileManager copyItemAtPath:plistURL.path toPath:destPath error:nil];
}

- (BOOL) isStartupItemInstalled:(NSURL *) plistURL; {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * fileName = [plistURL lastPathComponent];
	NSString * targetPath = [[@"~/Library/LaunchAgents/" stringByExpandingTildeInPath] stringByAppendingPathComponent:fileName];
	return [fileManager fileExistsAtPath:targetPath];
}

@end


#import "NSWorkspace+GWAdditions.h"

@implementation NSWorkspace (GWAdditions)

- (void) bringApplicationToFront:(NSDictionary *) appInfo {
	if(appInfo == nil) return;
	NSString * appath = [appInfo valueForKey:@"NSApplicationPath"];
	if(appath == nil) return;
	[self launchApplication:appath];
}

- (void) bringCurrentApplicationToFront {
	[self launchApplication:[[NSBundle mainBundle] bundlePath]];
}

- (void) bringApplicationToFrontFromPath:(NSString *) appPath {
	if(!appPath) return;
	[self launchApplication:appPath];
}

- (void) openSystemPreference:(NSString *) preferencesFileName {
	NSFileManager * fm = [NSFileManager defaultManager];
	if([fm fileExistsAtPath:[@"/System/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]]) {
		[[NSWorkspace sharedWorkspace] openFile:[@"/System/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]];
	} else if([fm fileExistsAtPath:[@"~/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]]) {
		[[NSWorkspace sharedWorkspace] openFile:[@"~/Library/PreferencePanes/" stringByAppendingString:preferencesFileName]];
	}
}

- (void) uninstallStartupLaunchdItem:(NSString *) plistName {
	NSFileManager * fm = [NSFileManager defaultManager];
	NSString * file = [[@"~/Library/LaunchAgents" stringByExpandingTildeInPath] stringByAppendingString:[@"/" stringByAppendingString:plistName]];
	[fm removeItemAtPath:file error:NULL];
}

- (void) installStartupLaunchdItem:(NSString *) plistName {
	if(!plistName)return;
	NSBundle * bndl = [NSBundle mainBundle];
	NSFileManager * fm = [NSFileManager defaultManager];
	NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
	[attrs setObject:[NSNumber numberWithUnsignedLong:448] forKey:NSFilePosixPermissions];
	NSString * path = [bndl pathForResource:[plistName stringByDeletingPathExtension] ofType:@"plist"];
	NSMutableDictionary * plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSString * executablepath = [bndl executablePath];
	[plist setObject:executablepath forKey:@"Program"];
	NSString * dest = [[@"~/Library/LaunchAgents" stringByExpandingTildeInPath] stringByAppendingString:[@"/" stringByAppendingString:plistName]];	
	#if MAC_OS_X_VERSION_MAX_ALLOWED > 1040
	[fm createDirectoryAtPath:[@"~/Library/LaunchAgents/" stringByExpandingTildeInPath] withIntermediateDirectories:TRUE attributes:attrs error:nil];
	#else
	[fm createDirectoryAtPath:[@"~/Library/LaunchAgents/" stringByExpandingTildeInPath] attributes:attrs];
	#endif
	[plist writeToFile:dest atomically:true];
}

@end

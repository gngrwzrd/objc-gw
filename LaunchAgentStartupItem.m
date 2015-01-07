
#import "LaunchAgentStartupItem.h"

@implementation LaunchAgentStartupItem

- (id) initWithExecutablePath:(NSString *) executablePath fileName:(NSString *) fileName label:(NSString *) label; {
	self = [super init];
	self.executablePath = executablePath;
	self.fileName = fileName;
	self.label = label;
	[self createAgentPath];
	return self;
}

- (id) initWithFileName:(NSString *) fileName label:(NSString *) label; {
	self = [self initWithExecutablePath:[NSBundle mainBundle].executablePath fileName:fileName label:label];
	return self;
}

- (NSURL *) launchAgentsPath {
	return [NSURL fileURLWithPath:[@"~/Library/LaunchAgents/" stringByExpandingTildeInPath]];
}

- (NSURL *) installedAgentPath {
	NSURL * launchAgents = [self launchAgentsPath];
	if(!self.fileName) {
		return nil;
	}
	NSURL * installedAgentPath = [launchAgents URLByAppendingPathComponent:self.fileName];
	return installedAgentPath;
}

- (void) createAgentPath {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSURL * launchAgentsPath = [self launchAgentsPath];
	if(![fileManager fileExistsAtPath:launchAgentsPath.path]) {
		NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
		NSNumber * perms = [NSNumber numberWithUnsignedLong:448]; //700 octal = 448 decimal
		[attrs setObject:perms forKey:NSFilePosixPermissions];
		[fileManager createDirectoryAtPath:launchAgentsPath.path withIntermediateDirectories:TRUE attributes:attrs error:nil];
	}
}

- (void) install {
	NSMutableDictionary * plist = [NSMutableDictionary dictionary];
	plist[@"Label"] = self.label;
	plist[@"LimitLoadToSessionType"] = @"Aqua";
	plist[@"RunAtLoad"] = @(TRUE);
	plist[@"Program"] = self.executablePath;
	if(self.programArguments) {
		plist[@"ProgramArguments"] = self.programArguments;
	}
	NSURL * plistPath = [self installedAgentPath];
	if(plistPath) {
		[plist writeToURL:plistPath atomically:TRUE];
	}
}

- (void) uninstall {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSURL * plistPath = [self installedAgentPath];
	if(plistPath) {
		[fileManager removeItemAtURL:plistPath error:nil];
	}
}

- (BOOL) isInstalled {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSURL * plistPath = [self installedAgentPath];
	BOOL isInstalled = FALSE;
	if(plistPath) {
		isInstalled = [fileManager fileExistsAtPath:plistPath.path];
		NSDictionary * plist = [NSDictionary dictionaryWithContentsOfURL:plistPath];
		if(plist) {
			NSString * program = plist[@"Program"];
			if(program && ![program isEqualToString:self.executablePath]) {
				[self uninstall];
				[self install];
			}
		}
	}
	return isInstalled;
}

@end

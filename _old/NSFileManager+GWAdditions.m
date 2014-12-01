
#import "NSFileManager+GWAdditions.h"

@implementation NSFileManager (GWAdditions)

#if TARGET_OS_MAC && (!TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR && !TARGET_OS_EMBEDDED)

- (NSString *) pathToFolderOfType:(const OSType) folderType shouldCreateFolder:(BOOL) create {
	FSRef ref;
	NSString * path = nil;
	if(FSFindFolder(kUserDomain,folderType,create,&ref) == noErr) {
		CFURLRef url = CFURLCreateFromFSRef(kCFAllocatorSystemDefault,&ref);
		path = (NSString *) CFURLCopyFileSystemPath(url, kCFURLPOSIXPathStyle);
		[path autorelease];
		CFRelease(url);
	}
	return path;
}

- (NSString *) applicationSupportFolder {
	return [self pathToFolderOfType:kApplicationSupportFolderType shouldCreateFolder:YES];
}

- (NSString *) thisApplicationsSupportFolder {
	NSString * appname = [[NSBundle mainBundle] bundleIdentifier];
	NSString * path = [[self applicationSupportFolder] stringByAppendingPathComponent:appname];
	if(![self fileExistsAtPath:path]) {
		#if MAC_OS_X_VERSION_MAX_ALLOWED < 1050
			if(![self createDirectoryAtPath:path attributes:nil]) path = nil;
		#else
			if(![self createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil]) path=nil;
		#endif
	}
	return path;
}

- (NSString *) thisApplicationsSupportFolderByAppName {
	NSString * appname = [[NSProcessInfo processInfo] processName];
	NSString * path = [[self applicationSupportFolder] stringByAppendingPathComponent:appname];
	if(![self fileExistsAtPath:path]) {
		#if MAC_OS_X_VERSION_MAX_ALLOWED < 1050
			if(![self createDirectoryAtPath:path attributes:nil]) path = nil;	
		#else
			if(![self createDirectoryAtPath:path withIntermediateDirectories:TRUE attributes:nil error:nil]) path=nil;
		#endif
	}
	return path;
}

#endif

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSString * ) writableDirectory {
	NSString * _writableDirectory = NULL;
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * version = [[UIDevice currentDevice] systemVersion];
	if([version isEqualToString:@"5.0"]) {
		_writableDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"] copy];
	} else if([version floatValue] >= 5.0) {
		_writableDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/NoBackup/"] copy];
		[fileManager createDirectoryAtPath:_writableDirectory withIntermediateDirectories:true attributes:nil error:nil];
		const char * attrName = "com.apple.MobileBackup";
		uint8_t attrValue = 1;
		setxattr([_writableDirectory UTF8String],attrName,&attrValue,sizeof(attrValue),0,0);
	} else {
		_writableDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/NoBackup/"] copy];
		[fileManager createDirectoryAtPath:_writableDirectory withIntermediateDirectories:true attributes:nil error:nil];
	}
	return [_writableDirectory autorelease];
}

+ (NSString *) fileByAppendingToWriteableDirectory:(NSString *) file {
	return [[NSFileManager writableDirectory] stringByAppendingFormat:@"/%@",file];
}

#endif

@end

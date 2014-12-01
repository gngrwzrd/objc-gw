
#include "GDCrashReporter_NSApplicationMain.h"
#include "GDBHelpers.h"

//static NSString * bp = NULL;
//static pid_t pid = 0;
//static LaunchedWrapper * launched;

@implementation LaunchedWrapper : NSObject {
}

- (void) applicationLaunched:(NSDictionary *) info {
	NSLog(@"app launched!");
}

@end

#if TARGET_OS_MAC > MAC_OS_X_VERSION_10_5
//uses snow leopard NSRunningApplication api.
static void bringApplicationToFrontByPID(pid_t pid) {
	NSRunningApplication * app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
	[app activateWithOptions:NSApplicationActivateAllWindows];
}
#endif

//uses old trick with NSWorkspace.
static void bringApplicationToFrontByBundlePath(NSString * bundlePath) {
	NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
	[workspace launchApplication:bundlePath];
}

int GDCrashReporter_NSApplicationMain(char * bundleId, int argc, char ** argv) {
	if(isGDBActive()) return NSApplicationMain(argc,(const char **)argv);
	char * gdc = getenv("GDCrashReporter");
	//if gdc is set this process is the child.
	if(gdc) return NSApplicationMain(argc,(const char **)argv);
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	//NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
	NSBundle * bundle = [NSBundle bundleWithIdentifier:[NSString stringWithUTF8String:bundleId]];
	NSDictionary * info = [bundle infoDictionary];
	NSString * MainApplicationName = [info objectForKey:@"CFBundleName"];
	NSString * MainApplicationPath = [bundle bundlePath];
	NSString * MainExecutablePath = [bundle executablePath];
	/*NSString * MainWrappedExecutable = [info objectForKey:@"GDCrashReporterWrappedExecutable"];
	if(MainWrappedExecutable) {
		MainExecutablePath = [MainExecutablePath stringByDeletingLastPathComponent];
		MainExecutablePath = [MainExecutablePath stringByAppendingPathComponent:MainWrappedExecutable];
	}*/
	NSString * GDCrashReporterAppName = [info objectForKey:@"GDCrashReporterAppName"];
	NSString * GDCrashReporterBundleId = [info objectForKey:@"GDCrashReporterBundleId"];
	NSString * GDCrashReporterRelativeBundlePath = [info objectForKey:@"GDCrashReporterRelativeBundlePath"];
	NSString * GDCrashReporterAbsoluteBundlePath = [info objectForKey:@"GDCrashReporterAbsoluteBundlePath"];
	NSString * GDCrashReporterRelativePath = [info objectForKey:@"GDCrashReporterRelativePath"];
	NSString * GDCrashReporterAbsolutePath = [info objectForKey:@"GDCrashReporterAbsolutePath"];
	NSString * GDCrashReporterCrashedAppName = MainApplicationName;
	NSString * GDCrashReporterCrashedAppBundleId = [info objectForKey:@"CFBundleIdentifier"];
	NSString * GDCrashReporterCrashedAppBundlePath = MainApplicationPath;
	NSString * GDCrashReporterWindowTitle = [info objectForKey:@"GDCrashReporterWindowTitle"];
	NSString * GDCrashReporterTitle = [info objectForKey:@"GDCrashReporterTitle"];
	NSString * GDCrashReporterExecutableAppPath;
	NSString * GDCrashReporterBundlePath;
	if(GDCrashReporterAbsolutePath) GDCrashReporterExecutableAppPath = GDCrashReporterAbsolutePath;
	else GDCrashReporterExecutableAppPath = [MainApplicationPath stringByAppendingPathComponent:GDCrashReporterRelativePath];
	if(GDCrashReporterAbsoluteBundlePath) GDCrashReporterBundlePath = GDCrashReporterAbsoluteBundlePath;
	else GDCrashReporterBundlePath = [MainApplicationPath stringByAppendingPathComponent:GDCrashReporterRelativeBundlePath];
	//whether or not I've got enough info to launch the crash reporter
	bool canLaunchCrashReporter = (GDCrashReporterAppName != NULL && GDCrashReporterBundleId != NULL &&
								   (GDCrashReporterRelativePath != NULL || GDCrashReporterAbsolutePath != NULL) &&
								   (GDCrashReporterRelativeBundlePath != NULL || GDCrashReporterAbsoluteBundlePath != NULL));
	char ** ex1Params = malloc(sizeof(char *) * 2); //start first executable info
	char * ex1 = strdup((char *)[MainExecutablePath UTF8String]);
	char * ex1n = strdup((char*)[MainApplicationName UTF8String]);
	ex1Params[0] = ex1n;
	ex1Params[1] = NULL;
	setenv("GDCrashReporter","1",1);
	setenv("GDCrashReporterWindowTitle",[GDCrashReporterWindowTitle UTF8String],1);
	setenv("GDCrashReporterTitle",[GDCrashReporterTitle UTF8String],1);
	setenv("GDCrashReporterCrashedAppName",[GDCrashReporterCrashedAppName UTF8String],1);
	setenv("GDCrashReporterCrashedAppBundleId",[GDCrashReporterCrashedAppBundleId UTF8String],1);
	setenv("GDCrashReporterCrashedAppBundlePath",[GDCrashReporterCrashedAppBundlePath UTF8String],1);
	pid_t child = fork();
	if(child==0) execvp(ex1,ex1Params); //launch myself with env set.
	//sleep(2); //short delay before requesting the app be brought to the front.
	//bringApplicationToFrontByBundlePath(MainApplicationPath);
	//#if TARGET_OS_MAC > MAC_OS_X_VERSION_10_5
	//bringApplicationToFrontByPID(child);
	//#endif
	//launched = [[LaunchedWrapper alloc] init];
	//[[workspace notificationCenter] addObserver:launched selector:@selector(applicationLaunced:) name:NSWorkspaceDidLaunchApplicationNotification object:nil];
	int waited,status; //start second executable info
	while((waited=(wait(&status)))) {
		if(waited == -1 && errno == EINTR) continue;
		if(waited != -1 && waited != child) continue;
		break;
	}
	if(!WIFSIGNALED(status) || !canLaunchCrashReporter) {
		[pool release];
		free(ex1);
		free(ex1n);
		free(ex1Params);
		return WEXITSTATUS(status);
	}
	char ** ex2Params = malloc(sizeof(char *) * 2); //start crash executable info
	char * ex2 = strdup((char*)[GDCrashReporterExecutableAppPath UTF8String]);
	char * ex2n = strdup((char *)[GDCrashReporterAppName UTF8String]);
	ex2Params[0] = ex2n;
	ex2Params[1] = NULL;
	child = fork();
	if(child == 0) {
		setsid();
		execvp(ex2,ex2Params);
	}
	//sleep(1); //short delay before requesting the app be brought to the front.
	//bringApplicationToFrontByBundlePath(GDCrashReporterBundlePath);
	//#if TARGET_OS_MAC > MAC_OS_X_VERSION_10_5
	//bringApplicationToFrontByPID(child);
	//#endif
	free(ex1);
	free(ex1n);
	free(ex1Params);
	free(ex2);
	free(ex2n);
	free(ex2Params);
	[pool release];
	//wait(NULL);
	return 0;
}

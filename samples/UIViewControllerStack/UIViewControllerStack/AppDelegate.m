
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	[self.window makeKeyAndVisible];
	return YES;
}

@end

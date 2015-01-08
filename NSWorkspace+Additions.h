
#import <Cocoa/Cocoa.h>

@interface NSWorkspace (Additions)

- (void) bringApplicationToFront;
- (void) bringApplicationToFrontIfInBackground;
- (BOOL) isFrontmostAppThisApp;
- (BOOL) isFrontmostAppThisBundle:(NSBundle *) bundle;


//these are deprecated. Use LaunchAgentStartupItem Class instead.
- (void) installStartupLaunchdItem:(NSURL *) plistURL;
- (void) uninstallStartupLaunchdItem:(NSURL *) plistURL;
- (BOOL) isStartupItemInstalled:(NSURL *) plistURL;

@end

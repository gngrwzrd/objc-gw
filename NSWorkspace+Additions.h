
#import <Cocoa/Cocoa.h>

@interface NSWorkspace (Additions)

- (void) bringApplicationToFront;
- (void) bringApplicationToFrontIfInBackground;
- (void) installStartupLaunchdItem:(NSURL *) plistURL;
- (void) uninstallStartupLaunchdItem:(NSURL *) plistURL;
- (BOOL) isStartupItemInstalled:(NSURL *) plistURL;
- (BOOL) isFrontmostAppThisApp;
- (BOOL) isFrontmostAppThisBundle:(NSBundle *) bundle;

@end


#import <Cocoa/Cocoa.h>

@interface NSWorkspace (Additions)

- (void) bringApplicationToFront;
- (void) installStartupLaunchdItem:(NSURL *) plistURL;
- (void) uninstallStartupLaunchdItem:(NSURL *) plistURL;
- (BOOL) isStartupItemInstalled:(NSURL *) plistURL;

@end

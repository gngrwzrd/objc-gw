
#import <Cocoa/Cocoa.h>

@interface NSWorkspace (Additions)

- (void) bringCurrentApplicationToFront;
- (void) installStartupLaunchdItem:(NSURL *) plistURL;
- (void) uninstallStartupLaunchdItem:(NSURL *) plistURL;
- (BOOL) isStartupItemInstalled:(NSURL *) plistURL;;

@end

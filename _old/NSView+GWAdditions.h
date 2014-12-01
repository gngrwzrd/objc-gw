
#import <Cocoa/Cocoa.h>

@interface NSView (GWAdditions)

+ (id) gw_loadViewNibNamed:(NSString *) nibName;
+ (id) gw_loadViewNibNamed:(NSString *) nibName inBundle:(NSBundle *) bundle retainingObjectWithTag:(NSUInteger) tag;

@end

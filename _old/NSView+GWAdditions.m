
#import "NSView+GWAdditions.h"
#import "gwmacros.h"

@implementation NSView (GWAdditions)

+ (id) gw_loadViewNibNamed:(NSString *) nibName {
	return [NSView gw_loadViewNibNamed:nibName inBundle:[NSBundle mainBundle] retainingObjectWithTag:1];
}

+ (id) gw_loadViewNibNamed:(NSString *) nibName inBundle:(NSBundle *) bundle retainingObjectWithTag:(NSUInteger) tag {
	NSArray * __autoreleasing nibs = nil;
	BOOL res = [bundle loadNibNamed:nibName owner:nil topLevelObjects:&nibs];
	if(!res || !nibs || nibs.count < 1) return nil;
	
	NSView * target = nil;
	for(NSView * view in nibs) {
		if(view.tag == tag) {
			target = view;
			break;
		}
	}
	
	SEL viewDidLoad = NSSelectorFromString(@"viewDidLoad");
	if(target && [target respondsToSelector:viewDidLoad]) {
		SuppressPerformSelectorLeakWarning(
			[target performSelector:viewDidLoad];
		);
	}
	
	return target;
}

@end

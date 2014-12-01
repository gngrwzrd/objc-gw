
#import "UIView+GWAdditions.h"

@implementation UIView (GWAdditions)

+ (id) gw_loadViewNibNamed:(NSString *) nibName {
	return [UIView gw_loadViewNibNamed:nibName inBundle:[NSBundle mainBundle] retainingObjectWithTag:1];
}

+ (id) gw_loadViewNibNamed:(NSString *) nibName inBundle:(NSBundle *) bundle retainingObjectWithTag:(NSUInteger) tag {
	NSArray * nibs = [bundle loadNibNamed:nibName owner:nil options:nil];
	if(!nibs || nibs.count < 1) return nil;
	
	UIView * target = nil;
	for(UIView * view in nibs) {
		if(view.tag == tag) {
			target = [view retain];
			break;
		}
	}
	
	if(target && [target respondsToSelector:@selector(viewDidLoad)]) {
		[target performSelector:@selector(viewDidLoad)];
	}
	
	return [target autorelease];
}

@end

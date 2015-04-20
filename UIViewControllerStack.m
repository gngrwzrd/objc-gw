
#import "UIViewControllerStack.h"

@interface UIViewControllerStack ()
@property NSMutableArray * viewControllers;
@end

@implementation UIViewControllerStack

- (void) defaultInit {
	self.viewControllers = [NSMutableArray array];
	self.animationDuration = .25;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self defaultInit];
	return self;
}

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	[self defaultInit];
	return self;
}

- (void) resizeViewController:(UIViewController *) viewController {
	if(!viewController) {
		return;
	}
	
	CGRect f = viewController.view.frame;
	UIViewController <UIViewControllerStackUpdating> * updating = (UIViewController <UIViewControllerStackUpdating> *) viewController;
	
	if([updating respondsToSelector:@selector(shouldResizeFrameForStackPush:)]) {
		BOOL resize = [updating shouldResizeFrameForStackPush:self];
		if(resize) {
			f.size.width = self.frame.size.width;
			f.size.height = self.frame.size.height;
			viewController.view.frame = f;
		}
	}
	
	if(self.alwaysResizePushedViews) {
		f.size.width = self.frame.size.width;
		f.size.height = self.frame.size.height;
		viewController.view.frame = f;
	}
}

- (void) animatePushFromController:(UIViewController *) fromController toController:(UIViewController *) toController withDuration:(CGFloat) duration {
	UIViewController <UIViewControllerStackUpdating> * toControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)toController;
	UIViewController <UIViewControllerStackUpdating> * fromControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)fromController;
	
	//move view controller off to right side and add as subview
	CGRect f = toController.view.frame;
	f.origin.y = 0;
	f.origin.x = self.frame.size.width;
	toController.view.frame = f;
	
	//resize view controllers
	[self resizeViewController:fromController];
	[self resizeViewController:toController];
	
	//add subview
	[self addSubview:toController.view];
	
	//setup animation options
	UIViewAnimationOptions options = 0;
	options |= UIViewAnimationOptionCurveEaseInOut;
	
	//notify the view controllers of what's about to happen
	if([toController respondsToSelector:@selector(viewStack:willShowView:wasAnimated:)]) {
		[toControllerUpdating viewStack:self willShowView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
	}
	
	if([fromController respondsToSelector:@selector(viewStack:willHideView:wasAnimated:)]) {
		[fromControllerUpdating viewStack:self willHideView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
	}
	
	//trigger animation, moving current off to the left, new view controller in from the right.
	[UIView animateWithDuration:duration delay:0 options:options animations:^{
		CGRect f;
		
		if(fromController) {
			f = fromController.view.frame;
			f.origin.y = 0;
			f.origin.x -= f.size.width;
			fromController.view.frame = f;
		}
		
		f = toController.view.frame;
		f.origin.y = 0;
		f.origin.x = 0;
		toController.view.frame = f;
		
	} completion:^(BOOL finished) {
		
		[fromController.view removeFromSuperview];
		
		if([fromController respondsToSelector:@selector(viewStack:didHideView:wasAnimated:)]) {
			[fromControllerUpdating viewStack:self didHideView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
		}
		
		if([toController respondsToSelector:@selector(viewStack:didShowView:wasAnimated:)]) {
			[toControllerUpdating viewStack:self didShowView:UIViewControllerStackOperationPush wasAnimated:(duration>0)];
		}
	}];
}

- (void) animatePopFromController:(UIViewController *) fromController toController:(UIViewController *) toController withDuration:(CGFloat)duration{
	UIViewController <UIViewControllerStackUpdating> * toControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)toController;
	UIViewController <UIViewControllerStackUpdating> * fromControllerUpdating = (UIViewController <UIViewControllerStackUpdating> *)fromController;
	
	//resize view controllers
	[self resizeViewController:fromController];
	[self resizeViewController:toController];
	
	//move the next view controller off to left of host view and add as subview
	if(toController) {
		CGRect f = toController.view.frame;
		f.origin.y = 0;
		f.origin.x = -(f.size.width);
		toController.view.frame = f;
		[self addSubview:toController.view];
	}
	
	//setup animation options
	UIViewAnimationOptions options = 0;
	options |= UIViewAnimationOptionCurveEaseInOut;
	
	//notify view controllers of what's about to happen
	if([fromController respondsToSelector:@selector(viewStack:willHideView:wasAnimated:)]) {
		[fromControllerUpdating viewStack:self willHideView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
	}
	
	if([toController respondsToSelector:@selector(viewStack:willShowView:wasAnimated:)]) {
		[toControllerUpdating viewStack:self willShowView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
	}
	
	//trigger animation, moving popped off to right, next view controller in from the left
	[UIView animateWithDuration:duration delay:0 options:options animations:^{
		
		CGRect f = fromController.view.frame;
		f.origin.x += self.frame.size.width;
		f.origin.y = 0;
		fromController.view.frame = f;
		
		if(toController) {
			f = toController.view.frame;
			f.origin.y = 0;
			f.origin.x = 0;
			toController.view.frame = f;
		}
		
	} completion:^(BOOL finished) {
		
		[fromController.view removeFromSuperview];
		
		if([fromController respondsToSelector:@selector(viewStack:didHideView:wasAnimated:)]) {
			[fromControllerUpdating viewStack:self didHideView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
		}
		
		if([toController respondsToSelector:@selector(viewStack:didShowView:wasAnimated:)]) {
			[toControllerUpdating viewStack:self didShowView:UIViewControllerStackOperationPop wasAnimated:(duration>0)];
		}
	}];
}

- (void) pushViewController:(UIViewController *) viewController animated:(BOOL) animated; {
	if(animated) {
		[self animatePushFromController:[self currentViewController] toController:viewController withDuration:self.animationDuration];
	} else {
		[self animatePushFromController:[self currentViewController] toController:viewController withDuration:0];
	}
	[self.viewControllers addObject:viewController];
}

- (void) pushViewControllers:(NSArray *) viewControllers; {
	[self.viewControllers addObjectsFromArray:viewControllers];
}

- (void) insertViewController:(UIViewController *) viewController atIndex:(NSInteger) index; {
	[self.viewControllers insertObject:viewController atIndex:index];
}

- (void) popViewControllerAnimated:(BOOL) animated; {
	UIViewController * current = [self currentViewControllerByRemovingLastObject];
	UIViewController * nxt = [self currentViewController];
	if(animated) {
		[self animatePopFromController:current toController:nxt withDuration:self.animationDuration];
	} else {
		[self animatePopFromController:current toController:nxt withDuration:0];
	}
}

- (void) popToRootViewControllerAnimated:(BOOL) animated; {
	UIViewController * current = [self currentViewController];
	UIViewController * nxt = self.viewControllers[0];
	if(animated) {
		[self animatePopFromController:current toController:nxt withDuration:self.animationDuration];
	} else {
		[self animatePopFromController:current toController:nxt withDuration:0];
	}
	[self.viewControllers removeAllObjects];
	[self.viewControllers addObject:nxt];
}

- (void) eraseStackAndPushViewController:(UIViewController *) viewController animated:(BOOL) animated; {
	if(animated) {
		[self animatePushFromController:self.currentViewController toController:viewController withDuration:self.animationDuration];
	} else {
		[self animatePushFromController:self.currentViewController toController:viewController withDuration:0];
	}
	[self.viewControllers removeAllObjects];
	[self.viewControllers addObject:viewController];
}

- (void) replaceCurrentViewControllerWithViewController:(UIViewController *) viewController animated:(BOOL) animated; {
	UIViewController * currentViewController = [self currentViewController];
	if(animated) {
		[self animatePushFromController:currentViewController toController:viewController withDuration:self.animationDuration];
	} else {
		[self animatePushFromController:currentViewController toController:viewController withDuration:0];
	}
	[_viewControllers removeObject:currentViewController];
	[_viewControllers addObject:viewController];
}

- (void) replaceViewController:(UIViewController *) viewController withViewController:(UIViewController *) newViewController; {
	NSInteger index = 0;
	for(UIViewController * vc in self.viewControllers) {
		if(vc == viewController) {
			index = [self.viewControllers indexOfObject:viewController];
		}
	}
	if(index != NSNotFound) {
		[self.viewControllers replaceObjectAtIndex:index withObject:newViewController];
	}
}

- (UIViewController *) currentViewController {
	if(self.viewControllers.count > 0) {
		return [self.viewControllers lastObject];
	}
	return nil;
}

- (UIViewController *) currentViewControllerByRemovingLastObject {
	UIViewController * current = [self currentViewController];
	if(current) {
		[self.viewControllers removeLastObject];
	}
	return current;
}

- (BOOL) canPopViewController {
	return self.viewControllers.count > 1;
}

- (NSInteger) stackSize {
	return self.viewControllers.count;
}

- (BOOL) hasViewController:(UIViewController *) viewController {
	for(UIViewController * vc in self.viewControllers) {
		if(vc == viewController) {
			return TRUE;
		}
	}
	return FALSE;
}

- (BOOL) hasViewControllerClass:(Class)cls {
	for(UIViewController * vc in self.viewControllers) {
		if([vc class] == cls) {
			return TRUE;
		}
	}
	return FALSE;
}

- (void) eraseStack {
	for(UIViewController * vc in self.viewControllers) {
		[vc.view removeFromSuperview];
	}
	[self.viewControllers removeAllObjects];
}

@end

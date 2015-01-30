
#import <UIKit/UIKit.h>

@class UIViewControllerStack;

typedef NS_ENUM(NSInteger,UIViewControllerStackOperation) {
	UIViewControllerStackOperationPush,
	UIViewControllerStackOperationPop
};

@protocol UIViewControllerStackUpdating <NSObject>
- (void) viewStack:(UIViewControllerStack *) viewStack willShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack willHideView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack didShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (void) viewStack:(UIViewControllerStack *) viewStack didHideView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated;
- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *) viewStack;
//- (CGPoint) contentOriginInViewStack:(UIViewControllerStack *) viewStack;
@end

IB_DESIGNABLE
@interface UIViewControllerStack : UIView

@property IBInspectable CGFloat animationDuration;
@property IBInspectable BOOL alwaysResizePushedViews;

//methods for pushing/popping and altering what's displayed.
- (void) pushViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) popViewControllerAnimated:(BOOL) animated;
- (void) popToRootViewControllerAnimated:(BOOL) animated;
- (void) eraseStackAndPushViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) replaceCurrentViewControllerWithViewController:(UIViewController *) viewController animated:(BOOL) animated;

//util methods for updating what's in the stack without effecting what's displayed.
- (void) pushViewControllers:(NSArray *) viewControllers;
- (void) insertViewController:(UIViewController *) viewController atIndex:(NSInteger) index;
- (void) replaceViewController:(UIViewController *) viewController withViewController:(UIViewController *) newViewController;

//completely erase stack and remove all subviews.
- (void) eraseStack;

//other utils
- (BOOL) canPopViewController;
- (BOOL) hasViewController:(UIViewController *) viewController;
- (BOOL) hasViewControllerClass:(Class) cls;
- (NSInteger) stackSize;
- (UIViewController *) currentViewController;

@end

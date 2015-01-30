
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

- (void) pushViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) pushViewControllersWithoutDisplaying:(NSArray *) viewControllers;
- (void) insertViewControllerWithoutDisplaying:(UIViewController *) viewController atIndex:(NSInteger) index;
- (void) popViewControllerAnimated:(BOOL) animated;
- (void) popToRootViewControllerAnimated:(BOOL) animated;
- (void) eraseStackAndPushViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) replaceCurrentViewControllerWithViewController:(UIViewController *) viewController animated:(BOOL) animated;
- (void) replaceViewController:(UIViewController *) viewController withViewController:(UIViewController *) newViewController;
- (void) eraseStack;
- (BOOL) canPopViewController;
- (BOOL) hasViewController:(UIViewController *) viewController;
- (BOOL) hasViewControllerClass:(Class) cls;
- (NSInteger) stackSize;
- (UIViewController *) currentViewController;

@end

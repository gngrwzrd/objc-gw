
#import "Content1ViewController.h"
#import "RootViewController.h"

@implementation Content1ViewController

- (IBAction) onBack:(id) sender {
	RootViewController * root = (RootViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
	[root.viewStack popViewControllerAnimated:TRUE];
}

@end

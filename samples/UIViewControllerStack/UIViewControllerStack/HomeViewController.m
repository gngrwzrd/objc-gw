
#import "HomeViewController.h"
#import "RootViewController.h"
#import "Content1ViewController.h"

@implementation HomeViewController

- (IBAction) onNext:(id)sender {
	RootViewController * root = (RootViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
	Content1ViewController * content1 = [[Content1ViewController alloc] initWithNibName:@"Content1ViewController" bundle:nil];
	[root.viewStack pushViewController:content1 animated:TRUE];
}

@end


#import "RootViewController.h"

@implementation RootViewController

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) onStart:(id) sender {
	HomeViewController * home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	[self.viewStack eraseStackAndPushViewController:home animated:FALSE];
}

@end

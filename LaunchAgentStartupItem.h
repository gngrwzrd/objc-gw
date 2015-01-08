
#import <Foundation/Foundation.h>

@interface LaunchAgentStartupItem : NSObject
@property NSString * label;
@property NSString * fileName;
@property NSString * executablePath;
@property NSArray * programArguments;
@property (nonatomic) BOOL isInstalled;
- (id) initWithFileName:(NSString *) fileName label:(NSString *) label; //this uses the main NSBundle executablePath.
- (id) initWithExecutablePath:(NSString *) executablePath fileName:(NSString *) fileName label:(NSString *) label;
- (void) install;
- (void) uninstall;

//if the launch agent plist is installed and the executable path is not the same
//as self.executablePath, it's uninstalled, and re-installed with the new path.
- (void) updateExecutablePath;
@end


#import <Foundation/Foundation.h>

@interface LaunchAgentStartupItem : NSObject
@property NSString * label;
@property NSString * fileName;
@property NSString * executablePath;
@property NSDictionary * programArguments;
@property (nonatomic) BOOL isInstalled;
- (id) initWithFileName:(NSString *) fileName label:(NSString *) label; //this uses the main NSBundle executablePath.
- (id) initWithExecutablePath:(NSString *) executablePath fileName:(NSString *) fileName label:(NSString *) label;
- (void) install;
- (void) uninstall;
@end

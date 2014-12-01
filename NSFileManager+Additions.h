
#import <Foundation/Foundation.h>

@interface NSFileManager (Additions)

- (NSURL *) applicationSupportDirectoryURLWithExecutableName;
- (NSURL *) applicationSupportDirectoryURLWithBundleId;
- (NSURL *) applicationSupportDirectoryURLWithDirName:(NSString *) supportDirName;

@end

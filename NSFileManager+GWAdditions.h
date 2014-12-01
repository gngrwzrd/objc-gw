
#import <Foundation/Foundation.h>

@interface NSFileManager (GWAdditions)

- (NSURL *) applicationSupportDirectoryURLWithExuecableName;
- (NSURL *) applicationSupportDirectoryURLWithBundleId;
- (NSURL *) applicationSupportDirectoryURLWithDirName:(NSString *) supportDirName;

@end

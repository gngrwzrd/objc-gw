
#import <Cocoa/Cocoa.h>
#import <sys/resource.h>

@interface GDULimit : NSObject

//Enables core dumps. This is the equivalent of running 'ulimit -c unlimited'
+ (void) enableCoreDumps;

@end

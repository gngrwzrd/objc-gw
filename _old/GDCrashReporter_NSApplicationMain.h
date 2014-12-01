
#include <assert.h>
#include <stdbool.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/sysctl.h>
#include <AvailabilityMacros.h>
#include <Availability.h>
#import <Cocoa/Cocoa.h>

int GDCrashReporter_NSApplicationMain(char * bundleId, int argc, char ** argv);

@interface LaunchedWrapper : NSObject {
}
- (void) applicationLaunched:(NSDictionary *) info;
@end

#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <sys/event.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/time.h>

@class GWKqueueWatcher;

NSString * const GWKqueueWatcherDidChange;

@protocol GWKqueueWatcherDelegate <NSObject>
- (void) kqueueWatcherDidChange:(GWKqueueWatcher *) watcher;
@end

@interface GWKqueueWatcher : NSObject {
	int _kqueueid;
	int _fd;
	CFFileDescriptorRef _kqref;
}

@property NSURL * url;
@property (assign) NSObject <GWKqueueWatcherDelegate> * delegate;
@property BOOL isWatching;

- (id) initWithURL:(NSURL *) url;
- (BOOL) canStartWatching;
- (BOOL) start;
- (BOOL) stop;

@end

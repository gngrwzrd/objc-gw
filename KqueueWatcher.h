
#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <sys/event.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <sys/time.h>

@class KqueueWatcher;

NSString * const KqueueWatcherDidChange;

@protocol KqueueWatcherDelegate <NSObject>
- (void) kqueueWatcherDidChange:(KqueueWatcher *) watcher;
@end

@interface KqueueWatcher : NSObject
@property (weak) NSObject <KqueueWatcherDelegate> * delegate;
@property NSURL * url;
@property BOOL isWatching;
- (id) initWithURL:(NSURL *) url;
- (BOOL) canStartWatching;
- (BOOL) start;
- (BOOL) stop;
@end


#import "KqueueWatcher.h"

NSString * const KqueueWatcherDidChange = @"KqueueWatcherDidChange";

@interface KqueueWatcher () {
	int _kqueueid;
	int _fd;
	CFFileDescriptorRef _kqref;
}
- (void) kqueueFired;
@end

static void KqueueWatcherCallback(CFFileDescriptorRef kqRef, CFOptionFlags callBackTypes, void * info) {
	KqueueWatcher * watcher = (__bridge KqueueWatcher *)info;
	[watcher kqueueFired];
}

@implementation KqueueWatcher

- (id) initWithURL:(NSURL *)url {
	self = [super init];
	_kqueueid = -1;
	_fd = -1;
	self.url = url;
	return self;
}

- (BOOL) start {
	if(_kqueueid < 0) {
		_kqueueid = kqueue();
		if(_kqueueid < 0) {
			return FALSE;
		}
	}
	
	if(_fd < 0) {
		_fd = open([self.url fileSystemRepresentation],O_EVTONLY);
		if(_fd < 0) {
			return FALSE;
		}
	}
	
	struct kevent evt;
	bzero(&evt,sizeof(evt));
	evt.ident  = _fd;
	evt.filter = EVFILT_VNODE;
	evt.flags  = EV_ADD | EV_CLEAR;
	evt.fflags = NOTE_WRITE;
	
	int res = kevent(_kqueueid,&evt,1,NULL,0,NULL);
	if(res < 0) {
		return FALSE;
	}
	
	if(!_kqref) {
		CFFileDescriptorContext context = {0,(__bridge void *)(self),NULL,NULL,NULL};
		_kqref = CFFileDescriptorCreate(NULL,_kqueueid,true,KqueueWatcherCallback,&context);
		if(!_kqref) {
			return FALSE;
		}
		CFRunLoopSourceRef rls = CFFileDescriptorCreateRunLoopSource(NULL,_kqref,0);
		CFRunLoopAddSource(CFRunLoopGetCurrent(),rls,kCFRunLoopDefaultMode);
		CFRelease(rls);
	}
	
	if(_kqref) {
		CFFileDescriptorEnableCallBacks(_kqref,kCFFileDescriptorReadCallBack);
	}
	
	self.isWatching = TRUE;
	
	return TRUE;
}

- (BOOL) stop {
	if(_kqueueid < 0) {
		return FALSE;
	}
	
	if(_fd < 0) {
		return FALSE;
	}
	
	struct kevent evt;
	bzero(&evt,sizeof(evt));
	evt.ident = _fd;
	evt.filter = EVFILT_VNODE;
	evt.flags = EV_DELETE;
	evt.fflags = NOTE_WRITE;
	
	int res = kevent(_kqueueid,&evt,1,NULL,0,NULL);
	if(res < 0) {
		return FALSE;
	}
	
	if(_kqref) {
		CFFileDescriptorDisableCallBacks(_kqref,kCFFileDescriptorReadCallBack);
	}
	
	self.isWatching = FALSE;
	
	return TRUE;
}

- (void) kqueueFired {
	if(_kqref) {
		struct kevent evt;
		bzero(&evt,sizeof(evt));
		
		struct timespec timeout;
		bzero(&timeout,sizeof(timeout));
		
		int eventCount = kevent(_kqueueid,NULL,0,&evt,1,&timeout);
		if(eventCount > 0) {
			if(self.delegate && [self.delegate conformsToProtocol:@protocol(KqueueWatcherDelegate)]) {
				[self.delegate kqueueWatcherDidChange:self];
			}
			[[NSNotificationCenter defaultCenter] postNotificationName:KqueueWatcherDidChange object:self];
		}
		
		CFFileDescriptorEnableCallBacks(_kqref,kCFFileDescriptorReadCallBack);
	}
}

- (BOOL) canStartWatching {
	if(!self.url) {
		return FALSE;
	}
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:self.url.path]) {
		return FALSE;
	}
	
	return TRUE;
}

- (void) dealloc {
	NSLog(@"DEALLOC: KqueueWatcher");
	if(self.isWatching) {
		[self stop];
	}
	if(_fd > -1) {
		close(_fd);
	}
	self.delegate = nil;
}

@end

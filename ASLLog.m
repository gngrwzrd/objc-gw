
#import "ASLLog.h"
#import "ASLLogManager.h"

@interface ASLLog ()
@property int fd;
@property aslclient client;
@end

@implementation ASLLog
@synthesize logToStdOut;

- (id) initWithSender:(NSString *) sender facility:(NSString *) facility connectImmediately:(Boolean) connectImmediately {
	if(self = [self init]) {
		uint32_t ops = 0;
		if(connectImmediately) ops |= ASL_OPT_NO_DELAY;
		self.client = asl_open([sender UTF8String],[facility UTF8String],ops);
	}
	return self;
}

- (int) setLogFile:(NSString *) logFile {
	if(self.fd > -1) {
		asl_remove_log_file(self.client,self.fd);
		close(self.fd);
	}
	self.fd = open([logFile UTF8String], O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH|S_IWOTH);
	if(self.fd < 0) {
		return self.fd;
	}
	asl_add_log_file(self.client,self.fd);
	return 0;
}

- (void) alert:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_ALERT,[message UTF8String],NULL);
	asl_free(m);
}

- (void) critical:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_CRIT,[message UTF8String],NULL);
	asl_free(m);
}

- (void) debug:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_DEBUG,[message UTF8String],NULL);
	asl_free(m);
}

- (void) emergency:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_EMERG,[message UTF8String],NULL);
	asl_free(m);
}

- (void) error:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_ERR,[message UTF8String],NULL);
	asl_free(m);
}

- (void) info:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_INFO,[message UTF8String],NULL);
	asl_free(m);
}

- (void) notice:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_NOTICE,[message UTF8String],NULL);
	asl_free(m);
}

- (void) warning:(NSString *) message {
	if(![ASLLogManager sharedInstance].enabled) return;
	if(logToStdOut) printf("%s",[message UTF8String]);
	aslmsg m = asl_new(ASL_TYPE_MSG);
	asl_log(self.client,m,ASL_LEVEL_WARNING,[message UTF8String],NULL);
	asl_free(m);
}

- (void) close {
	if(self.fd > 0) {
		asl_remove_log_file(self.client,self.fd);
	}
	asl_close(self.client);
}

- (void) dealloc {
	[self close];
}

@end

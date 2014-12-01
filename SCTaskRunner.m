
#import "SCTaskRunner.h"

@implementation SCTaskRunner

- (id) init {
	self = [super init];
	self.task = [[NSTask alloc] init];
	self.data = [NSMutableData data];
	[self setupPipesAndNotifications];
	return self;
}

- (id) initWithStandardInput:(NSPipe *) standardInput {
	self = [self init];
	self.standardInput = standardInput;
	return self;
}

- (void) setupPipesAndNotifications {
	self.standardOutput = [[NSPipe alloc] init];
	self.standardError = [[NSPipe alloc] init];
	self.task.standardOutput = self.standardOutput;
	self.task.standardError = self.standardError;
	
	NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
	
	//add notification to task for termination
	[nfc addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:self.task];
	
	//add notifications for read data on standard out and standard error
	[nfc addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleDataAvailableNotification object:self.standardOutput.fileHandleForReading];
	[nfc addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleDataAvailableNotification object:self.standardError.fileHandleForReading];
	[self.standardOutput.fileHandleForReading waitForDataInBackgroundAndNotify];
	[self.standardError.fileHandleForReading waitForDataInBackgroundAndNotify];
	
	if(self.standardInput) {
		self.task.standardInput = self.standardInput;
	}
}

- (void) dataAvailableForFileHandle:(NSFileHandle *) fileHandle {
	NSData * data = [fileHandle availableData];
	
	if(data.length > 0) {
		if(self.collectDataUntilTerminated) {
			[self.data appendData:data];
		} else {
			
			if(self.delegate && [self.delegate respondsToSelector:@selector(taskRunner:didReadData:)]) {
				[self.delegate taskRunner:self didReadData:data];
			}
			
			if(fileHandle == self.standardOutput.fileHandleForReading) {
				if(self.delegate && [self.delegate respondsToSelector:@selector(taskRunner:didReadDataFromStdOut:)]) {
					[self.delegate taskRunner:self didReadDataFromStdOut:data];
				}
			}
			
			if(fileHandle == self.standardError.fileHandleForReading) {
				if(self.delegate && [self.delegate respondsToSelector:@selector(taskRunner:didReadDataFromStdErr:)]) {
					[self.delegate taskRunner:self didReadDataFromStdErr:data];
				}
			}
		}
	}
	
	if(!_terminated) {
		[fileHandle waitForDataInBackgroundAndNotify];
	}
}

- (void) dataAvailable:(NSNotification *) notification {
	NSFileHandle * fileHandle = notification.object;
	[self dataAvailableForFileHandle:fileHandle];
}

- (void) taskTerminated:(NSNotification *) notification {
	_terminated = TRUE;
	[self dataAvailableForFileHandle:self.standardOutput.fileHandleForReading];
	[self dataAvailableForFileHandle:self.standardError.fileHandleForReading];
	if(self.delegate && [self.delegate respondsToSelector:@selector(taskRunnerTerminated:)]) {
		[self.delegate taskRunnerTerminated:self];
	}
}

- (void) dealloc {
	NSLog(@"DEALLOC: SCTaskRunner");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.task terminate];
	self.task = nil;
	self.delegate = nil;
	self.standardOutput = nil;
	self.standardError = nil;
	self.standardInput = nil;
}

@end

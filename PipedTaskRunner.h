
#import <Foundation/Foundation.h>

@class PipedTaskRunner;

@protocol PipedTaskRunnerDelegate <NSObject>
@optional
- (void) taskRunner:(PipedTaskRunner *) taskRunner didReadData:(NSData *) data;
- (void) taskRunner:(PipedTaskRunner *) taskRunner didReadDataFromStdOut:(NSData *) data;
- (void) taskRunner:(PipedTaskRunner *) taskRunner didReadDataFromStdErr:(NSData *) data;
- (void) taskRunnerTerminated:(PipedTaskRunner *) taskRunner;
@end

@interface PipedTaskRunner : NSObject {
	BOOL _terminated;
}

@property (assign) NSObject <PipedTaskRunnerDelegate> * delegate;
@property BOOL collectDataUntilTerminated;
@property NSTask * task;
@property NSPipe * standardInput;
@property NSPipe * standardOutput;
@property NSPipe * standardError;
@property NSMutableData * data;
- (id) initWithStandardInput:(NSPipe *) pipe;

@end

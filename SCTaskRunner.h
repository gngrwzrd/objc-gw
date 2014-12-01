
#import <Foundation/Foundation.h>

@class SCTaskRunner;

@protocol SCTaskRunnerDelegate <NSObject>
@optional
- (void) taskRunner:(SCTaskRunner *) taskRunner didReadData:(NSData *) data;
- (void) taskRunner:(SCTaskRunner *) taskRunner didReadDataFromStdOut:(NSData *) data;
- (void) taskRunner:(SCTaskRunner *) taskRunner didReadDataFromStdErr:(NSData *) data;
- (void) taskRunnerTerminated:(SCTaskRunner *) taskRunner;
@end

@interface SCTaskRunner : NSObject {
	BOOL _terminated;
}
@property (assign) NSObject <SCTaskRunnerDelegate> * delegate;
@property BOOL collectDataUntilTerminated;
@property NSTask * task;
@property NSPipe * standardInput;
@property NSPipe * standardOutput;
@property NSPipe * standardError;
@property NSMutableData * data;
- (id) initWithStandardInput:(NSPipe *) pipe;
@end

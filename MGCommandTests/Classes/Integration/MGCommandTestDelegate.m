#import "MGCommandTestDelegate.h"
#import "TestableMGCommandGroup.h"
#import "MGBlockCommand.h"
#import "MGAsyncBlockCommand.h"
#import "TestableMGSequentialCommandGroup.h"


@implementation MGCommandTestDelegate {
}

- (void)executeEmptyMGCommandGroup {
    TestableMGCommandGroup *group = [[TestableMGCommandGroup alloc] initWithDelegate: self];
    [group execute];
}

- (void)executeSynchronousMGCommandGroup {
    TestableMGCommandGroup *group = [[TestableMGCommandGroup alloc] initWithDelegate: self];
    [group addCommand: [[MGBlockCommand alloc]
            initWithExecutionHandler: ^{
                [self commandExecuted];
            }]];

    [group execute];
}

- (void)executeAsynchronousMGCommandGroup {
    __weak __typeof (self) weakBlock = self;
    TestableMGCommandGroup *group = [[TestableMGCommandGroup alloc] initWithDelegate: self];
    group.completeHandler = ^{
        [weakBlock asyncCommandsCompleted];
    };

    [group addCommand: [[MGAsyncBlockCommand alloc]
            initWithExecutionHandler: ^(MGCommandCompleteHandler completeHandler) {

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [weakBlock commandExecuted];
                    completeHandler();
                });
            }
    ]];

    [group execute];
}

- (void)executeEmptyMGSequentialCommandGroup {
    TestableMGSequentialCommandGroup *group = [[TestableMGSequentialCommandGroup alloc] initWithDelegate: self];
    [group execute];
}

- (void)executeSynchronousMGSequentialCommandGroup {
    TestableMGSequentialCommandGroup *group = [[TestableMGSequentialCommandGroup alloc] initWithDelegate: self];
    [group addCommand: [[MGBlockCommand alloc]
            initWithExecutionHandler: ^{
                [self commandExecuted];
            }]];

    [group execute];
}

- (void)executeAsynchronousMGSequentialCommandGroup {
    __weak __typeof (self) weakBlock = self;
    TestableMGSequentialCommandGroup *group = [[TestableMGSequentialCommandGroup alloc] initWithDelegate: self];
    group.completeHandler = ^{
        [weakBlock asyncCommandsCompleted];
    };

    [group addCommand: [[MGAsyncBlockCommand alloc]
            initWithExecutionHandler: ^(MGCommandCompleteHandler completeHandler) {

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [weakBlock commandExecuted];
                    completeHandler();
                });
            }
    ]];

    [group execute];
}


- (void)asyncCommandsCompleted {
}

- (void)commandExecuted {
}

- (void)deallocCalled {
}

@end
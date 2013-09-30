#import <Foundation/Foundation.h>

#import "MGCommand.h"
#import "MGCommandGroup.h"

@interface MGCommandTestDelegate : NSObject

- (void)executeEmptyMGCommandGroup;

- (void)executeSynchronousMGCommandGroup;

- (void)executeAsynchronousMGCommandGroup;

- (void)executeEmptyMGSequentialCommandGroup;

- (void)executeSynchronousMGSequentialCommandGroup;

- (void)executeAsynchronousMGSequentialCommandGroup;

- (void)asyncCommandsCompleted;

- (void)commandExecuted;

- (void)deallocCalled;

@end
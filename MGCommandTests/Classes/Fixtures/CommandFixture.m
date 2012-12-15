#import "CommandFixture.h"

@implementation AsyncTestCommand

- (void)execute
{
	[self performSelector:@selector(finishExecute)
			   withObject:nil
			   afterDelay:0.1];
}

- (void)finishExecute
{
	_callCount = COMMAND_CALL_COUNT++;
	_callback();
}

@end

@implementation TestCommand

- (void)execute
{
	_callCount = COMMAND_CALL_COUNT++;
}

@end

@implementation AsyncDirectFinishTestCommand

- (void)execute
{
	_callCount = COMMAND_CALL_COUNT++;
	_callback();
}

@end
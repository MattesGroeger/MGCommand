#import "MGSequentialCommandGroup.h"


@implementation MGSequentialCommandGroup

- (void)execute
{
	[self executeNextCommand];
}

- (void)executeNextCommand
{
	if (_commandIndex >= self.commands.count)
	{
		self.callback();
		return;
	}

	id <MGCommand> nextCommand = self.commands[_commandIndex];
	_commandIndex++;

	if ([nextCommand conformsToProtocol:@protocol(MGAsyncCommand)])
	{
		id <MGAsyncCommand> nextAsyncCommand = (id <MGAsyncCommand>) nextCommand;
		nextAsyncCommand.callback = ^
		{
			[self executeNextCommand];
		};
		[nextAsyncCommand execute];
	}
	else
	{
		[nextCommand execute];
		[self executeNextCommand];
	}
}

@end
#import "MGCommandGroup.h"


@implementation MGCommandGroup

- (id)init
{
	self = [super init];

	if (self)
	{
		_commands = [NSMutableArray array];
	}

	return self;
}

- (void)execute
{
	__block NSUInteger remainingCallbacks = [_commands count];

	CommandCallback subCallback = ^
	{
		remainingCallbacks--;

		if (remainingCallbacks == 0)
		{
			_callback();
		}
	};

	for (id <MGCommand> command in _commands)
	{
		if ([command conformsToProtocol:@protocol(MGAsyncCommand)])
		{
			id <MGAsyncCommand> asyncCommand = (id <MGAsyncCommand>)command;
			asyncCommand.callback = subCallback;

			[command execute];
		}
		else
		{
			[command execute];

			subCallback();
		}
	}
}

- (void)addCommand:(id <MGCommand>)command
{
	NSAssert(![_commands containsObject:command],
		@"Can't add the same command instance twice!");

	[_commands addObject:command];
}

- (NSUInteger)count
{
	return _commands.count;
}

@end
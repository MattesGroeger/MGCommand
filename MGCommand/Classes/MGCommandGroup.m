/*
 * Copyright (c) 2012 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
	NSAssert(!_executing, @"Can't execute command group while already executing!");

	_executing = YES;
	[self processExecute];
}

- (void)processExecute
{
	__block NSUInteger remainingCallbacks = [_commands count];

	CommandCallback subCallback = ^
	{
		remainingCallbacks--;

		if (remainingCallbacks == 0)
		{
			[self finishExecution];
			return;
		}
	};

	for (id <MGCommand> command in _commands)
	{
		if ([command conformsToProtocol:@protocol(MGAsyncCommand)])
		{
			id <MGAsyncCommand> asyncCommand = (id <MGAsyncCommand>) command;
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

- (void)finishExecution
{
	_executing = NO;

	if (_callback)
	{
		_callback();
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

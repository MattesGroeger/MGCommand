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
#import "MGCommandExecutor.h"

@implementation MGCommandGroup

+ (id)autoStartGroup
{
	return [[MGCommandGroup alloc] initWithAutoStart:YES];
}

- (id)init
{
	return [self initWithAutoStart:NO];
}

- (id)initWithAutoStart:(BOOL)autoStart
{
	self = [super init];

	if (self)
	{
		_userInfo = [NSMutableDictionary dictionary];
		_autoStart = autoStart;
		_commands = [NSMutableArray array];
		_commandExecuter = [[MGCommandExecutor alloc]
				initWithCompleteCallback:^(id <MGCommand> command)
		{
			[_commands removeObject:command];
			[self callBackWhenDone];
		}];
	}

	return self;
}

- (void)addCommand:(id <MGCommand>)command
{
	NSAssert(![_commands containsObject:command],
		@"Can't add the same command instance twice!");

	[_commands addObject:command];

	if (_autoStart && !_commandExecuter.active)
	{
		[self execute];
	}
}

- (void)execute
{
	NSAssert(!_commandExecuter.active,
		@"Can't execute command group while already executing!");

	[self callBackWhenDone];

	for (id <MGCommand> command in [_commands copy])
	{
		[_commandExecuter executeCommand:command withUserInfo:_userInfo];
	}
}

- (NSUInteger)count
{
	return _commands.count;
}

- (void)callBackWhenDone
{
	if (_commands.count == 0)
	{
		if (_completeHandler)
		{
			_completeHandler();
		}
	}
}

- (void)cancel
{
	[self removeNotExecutedCommands];

	[_commandExecuter cancelExecution];
}

- (void)removeNotExecutedCommands
{
	NSMutableArray *commandsToRemove = [NSMutableArray arrayWithArray:_commands];

	for (id command in _commandExecuter.activeCommands)
	{
		[commandsToRemove removeObject:command];
	}

	[_commands removeObjectsInArray:commandsToRemove];
}

@end

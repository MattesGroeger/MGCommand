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

#import "MGCommandExecutor.h"

@implementation MGCommandExecutor

- (id)initWithCompleteCallback:(CommandExecutionCallback)completeCallback
{
	self = [super init];

	if (self)
	{
		_commandCallback = completeCallback;
		_activeCommands = [NSMutableArray array];
	}

	return self;
}

- (id)init
{
	return [self initWithCompleteCallback:nil];
}

- (BOOL)active
{
	return _activeCommands.count > 0;
}

- (void)executeCommand:(id <MGCommand>)command withUserInfo:(NSMutableDictionary *)userInfo
{
	CommandCallback subCallback = ^
	{
		[_activeCommands removeObject:command];

		if (_commandCallback)
		{
			_commandCallback(command);
		}
	};

	NSAssert(![_activeCommands containsObject:command], @"Can't execute the same command instance twice!");

	[_activeCommands addObject:command];

	if (userInfo && [command respondsToSelector:@selector(setUserInfo:)])
	{
		[command setUserInfo:userInfo];
	}

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

@end
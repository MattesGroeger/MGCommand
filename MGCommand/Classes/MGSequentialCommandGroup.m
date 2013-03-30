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

#import "MGSequentialCommandGroup.h"
#import "MGCommandExecutor.h"


@implementation MGSequentialCommandGroup

+ (id)autoStartGroup
{
	return [[MGSequentialCommandGroup alloc] initWithAutoStart:YES];
}

- (id)initWithAutoStart:(BOOL)autoStart
{
	self = [super initWithAutoStart:autoStart];

	if (self)
	{
		_autoStart = autoStart;
		_commandExecuter = [[MGCommandExecutor alloc]
				initWithCompleteCallback:^(id <MGCommand> command)
		{
			[_commands removeObject:command];
			[self executeNext];
		}];
	}

	return self;
}

- (void)execute
{
	NSAssert(!_commandExecuter.active,
		@"Can't execute command group while already executing!");

	[self executeNext];
}

- (void)executeNext
{
	if (_commands.count <= 0)
	{
		if (self.completeHandler)
		{
			self.completeHandler();
		}

		return;
	}

	id <MGCommand> nextCommand = [_commands objectAtIndex:0];
	[_commandExecuter executeCommand:nextCommand withUserInfo:self.userInfo];
}

@end
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


@implementation MGSequentialCommandGroup

- (void)processExecute
{
	if (_commandIndex >= self.commands.count)
	{
		[self finishExecution];
		return;
	}

	id <MGCommand> nextCommand = self.commands[_commandIndex];
	_commandIndex++;

	if ([nextCommand conformsToProtocol:@protocol(MGAsyncCommand)])
	{
		id <MGAsyncCommand> nextAsyncCommand = (id <MGAsyncCommand>) nextCommand;
		nextAsyncCommand.callback = ^
		{
			[self processExecute];
		};
		[nextAsyncCommand execute];
	}
	else
	{
		[nextCommand execute];
		[self processExecute];
	}
}

@end
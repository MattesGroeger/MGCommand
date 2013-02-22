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

@implementation CancellableTestCommand

- (void)execute
{
	[self performSelector:@selector(finishExecute)
			   withObject:nil
			   afterDelay:0.1];
}

- (void)cancel
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)finishExecute
{
	_callCount = COMMAND_CALL_COUNT++;
	_callback();
}

@end

@implementation TestCommand

- (id)initWithKey:(NSString *)key value:(NSString *)value
{
	self = [super init];

	if (self)
	{
		_key = key;
		_value = value;
	}

	return self;
}

- (void)execute
{
	if (_key && _value)
	{
		_userInfo[_key] = _value;
	}

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
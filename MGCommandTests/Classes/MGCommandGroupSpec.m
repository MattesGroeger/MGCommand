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

#import "Kiwi.h"
#import "MGCommandGroup.h"
#import "CommandFixture.h"

SPEC_BEGIN(MGCommandGroupSpec)

describe(@"MGCommandGroup", ^
{
	__block MGCommandGroup *commandGroup;

	beforeEach(^
	{
		commandGroup = [[MGCommandGroup alloc] init];
	});

	it(@"should not be auto start group", ^
	{
		[[theValue(commandGroup.autoStart) should] equal:theValue(NO)];
	});

	context(@"without commands", ^
	{
		it(@"should have count of 0", ^
		{
			[[theValue(commandGroup.count) should] equal:theValue(0)];
		});

		it(@"should finish instantly", ^
		{
			__block NSUInteger callbackCount = 0;

			commandGroup.callback = ^
			{
				callbackCount++;
			};

			[commandGroup execute];

			[[theValue(callbackCount) should] equal:theValue(1)];
		});

		it(@"should add commands", ^
		{
			id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];
			id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];

			[commandGroup addCommand:command1];
			[commandGroup addCommand:command2];

			[[theValue(commandGroup.count) should] equal:theValue(2)];
		});

		it(@"should fail to add same command instance twice", ^
		{
			id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];

			[commandGroup addCommand:command1];

			[[theBlock(^
			{
				[commandGroup addCommand:command1];
			}) should] raiseWithReason:@"Can't add the same command instance twice!"];
		});
	});

	context(@"with autostart group", ^
	{
		__block MGCommandGroup *autoStartGroup;

		beforeEach(^
		{
			autoStartGroup = [[MGCommandGroup alloc] initWithAutoStart:YES];
		});

		it(@"should be properly configured", ^
		{
			[[autoStartGroup should] beKindOfClass:[MGCommandGroup class]];
			[[[MGCommandGroup autoStartGroup] should] beKindOfClass:[MGCommandGroup class]];
		});

		it(@"should execute commands", ^
		{
			__block id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];
			__block id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];
			__block BOOL callbackExecuted = NO;

			[[command1 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(execute)];

			autoStartGroup.callback = ^
			{
				callbackExecuted = YES;
			};

			[autoStartGroup addCommand:command1];
			[autoStartGroup addCommand:command2];

			[[theValue(callbackExecuted) should] equal:theValue(YES)];
		});
	});

	context(@"with two syncronous commands", ^
	{
		__block id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];
		__block id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];

		beforeEach(^
		{
			[commandGroup addCommand:command1];
			[commandGroup addCommand:command2];
		});

		it(@"should work without callback beeing set", ^
		{
			[[command1 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(execute)];

			[commandGroup execute];
		});

		it(@"should execute commands", ^
		{
			__block BOOL callbackExecuted = NO;
			[[command1 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(execute)];

			commandGroup.callback = ^
			{
				callbackExecuted = YES;
			};

			[commandGroup execute];

			[[theValue(callbackExecuted) should] equal:theValue(YES)];
		});
	});

	context(@"with two asyncronous commands", ^
	{
		__block id command1 = [[AsyncTestCommand alloc] init];
		__block id command2 = [[AsyncTestCommand alloc] init];

		beforeEach(^
		{
			[commandGroup addCommand:command1];
			[commandGroup addCommand:command2];
		});

		it(@"should execute commands", ^
		{
			id mockReceiver = [KWMock mock];

			commandGroup.callback = ^
			{
				[mockReceiver performSelector:@selector(testCall)];
			};

			[commandGroup execute];

			[[mockReceiver shouldEventuallyBeforeTimingOutAfter(2.0)] receive:@selector(testCall)];
		});

		it(@"should fail to call execute twice", ^
		{
			[commandGroup execute];

			[[theBlock(^
			{
				[commandGroup execute];
			}) should] raiseWithReason:@"Can't execute command group while already executing!"];
		});
	});

	context(@"with one synchronous and one asyncronous command", ^
	{
		__block id command1 = [[AsyncTestCommand alloc] init];
		__block id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];

		beforeEach(^
		{
			[commandGroup addCommand:command1];
			[commandGroup addCommand:command2];
		});

		it(@"should execute commands", ^
		{
			id mockReceiver = [KWMock mock];

			commandGroup.callback = ^
			{
				[mockReceiver performSelector:@selector(testCall)];
			};

			[[command2 should] receive:@selector(execute)];

			[commandGroup execute];

			[[mockReceiver shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(testCall)];
		});
	});
});

SPEC_END
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

	context(@"without commands", ^
	{
		it(@"should have count of 0", ^
		{
			[[theValue(commandGroup.count) should] equal:theValue(0)];
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

	context(@"with two syncronous commands", ^
	{
		__block id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];
		__block id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];

		beforeEach(^
		{
			[commandGroup addCommand:command1];
			[commandGroup addCommand:command2];
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

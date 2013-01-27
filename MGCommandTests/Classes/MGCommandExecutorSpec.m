#import "Kiwi.h"
#import "MGCommandExecutor.h"
#import "CommandFixture.h"

SPEC_BEGIN(MGCommandExecutorSpec)

describe(@"MGCommandExecutor", ^
{
	__block MGCommandExecutor *executor;

	beforeEach(^
	{
		executor = [[MGCommandExecutor alloc] init];
	});

	context(@"without execution", ^
	{
		id command1 = [KWMock nullMockForProtocol:@protocol(MGAsyncCommand)];
		id command2 = [KWMock nullMockForProtocol:@protocol(MGAsyncCommand)];

		it(@"should have no active commands", ^
		{
			[[executor.activeCommands should] haveCountOf:0];
			[[theValue(executor.active) should] equal:theValue(NO)];
		});

		it(@"should execute command", ^
		{
			[[command1 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(execute)];

			[executor executeCommand:command1];
			[executor executeCommand:command2];

			[[executor.activeCommands should] haveCountOf:2];
			[[theValue(executor.active) should] equal:theValue(YES)];
		});

		it(@"should fail to execute same command instance twice", ^
		{
			[[command1 should] receive:@selector(execute)];

			[executor executeCommand:command1];

			[[theBlock(^
			{
				[executor executeCommand:command1];
			}) should] raiseWithReason:@"Can't execute the same command instance twice!"];
		});
	});

	context(@"with two syncronous commands", ^
	{
		__block id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];
		__block id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];

		it(@"should execute commands", ^
		{
			[[command1 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(execute)];

			[executor executeCommand:command1];
			[executor executeCommand:command2];

			[[executor.activeCommands should] haveCountOf:0];
			[[theValue(executor.active) should] equal:theValue(NO)];
		});

		context(@"with callback", ^
		{
			it(@"should call callback for each command", ^
			{
				__block NSUInteger callbackCount = 0;
				executor.commandCallback = ^(id <MGCommand> command)
				{
					[[(NSObject *)command shouldNot] beNil];
					callbackCount++;
				};

				[[command1 should] receive:@selector(execute)];
				[[command2 should] receive:@selector(execute)];

				[executor executeCommand:command1];
				[executor executeCommand:command2];

				[[theValue(callbackCount) should] equal:theValue(2)];
			});
		});
	});

	context(@"with two asyncronous commands", ^
	{
		__block id command1 = [[AsyncTestCommand alloc] init];
		__block id command2 = [[AsyncTestCommand alloc] init];

		it(@"should execute commands", ^
		{
			id mockReceiver = [KWMock mock];

			executor.commandCallback = ^(id <MGCommand> command)
			{
				[mockReceiver performSelector:@selector(testCall)];
			};

			[executor executeCommand:command1];
			[executor executeCommand:command2];

			[[executor.activeCommands should] haveCountOf:2];
			[[theValue(executor.active) should] equal:theValue(YES)];
			[[mockReceiver shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(testCall) withCount:2];
			[[executor.activeCommands shouldEventuallyBeforeTimingOutAfter(1.0)] haveCountOf:0];
			[[theValue(executor.active) shouldEventuallyBeforeTimingOutAfter(1.0)] equal:theValue(NO)];
		});
	});
});

SPEC_END
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

		it(@"should cancel without errors", ^
		{
			[executor cancelExecution];

			[[executor.activeCommands should] haveCountOf:0];
			[[theValue(executor.active) should] equal:theValue(NO)];
		});

		it(@"should execute command", ^
		{
			[[command1 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(execute)];

			[executor executeCommand:command1 withUserInfo:nil];
			[executor executeCommand:command2 withUserInfo:nil];

			[[executor.activeCommands should] haveCountOf:2];
			[[theValue(executor.active) should] equal:theValue(YES)];
		});

		it(@"should fail to execute same command instance twice", ^
		{
			[[command1 should] receive:@selector(execute)];

			[executor executeCommand:command1 withUserInfo:nil];

			[[theBlock(^
			{
				[executor executeCommand:command1 withUserInfo:nil];
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

			[executor executeCommand:command1 withUserInfo:nil];
			[executor executeCommand:command2 withUserInfo:nil];

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

				[executor executeCommand:command1 withUserInfo:nil];
				[executor executeCommand:command2 withUserInfo:nil];

				[[theValue(callbackCount) should] equal:theValue(2)];
			});

			it(@"should cancel commands", ^
			{
				__block NSUInteger callbackCount = 0;
				executor.commandCallback = ^(id <MGCommand> command)
				{
					[[(NSObject *)command shouldNot] beNil];
					callbackCount++;
				};

				[[command1 should] receive:@selector(execute)];
				[[command2 should] receive:@selector(execute)];

				[executor executeCommand:command1 withUserInfo:nil];
				[executor executeCommand:command2 withUserInfo:nil];
				[executor cancelExecution];

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

			[executor executeCommand:command1 withUserInfo:nil];
			[executor executeCommand:command2 withUserInfo:nil];

			[[executor.activeCommands should] haveCountOf:2];
			[[theValue(executor.active) should] equal:theValue(YES)];
			[[mockReceiver shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(testCall) withCount:2];
			[[executor.activeCommands shouldEventuallyBeforeTimingOutAfter(1.0)] haveCountOf:0];
			[[theValue(executor.active) shouldEventuallyBeforeTimingOutAfter(1.0)] equal:theValue(NO)];
		});

		it(@"should cancel commands", ^
		{
			id mockReceiver = [KWMock mock];
			[[mockReceiver shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(testCall) withCount:2];

			executor.commandCallback = ^(id <MGCommand> command)
			{
				[mockReceiver performSelector:@selector(testCall)];
			};

			[executor executeCommand:command1 withUserInfo:nil];
			[executor executeCommand:command2 withUserInfo:nil];
			[executor cancelExecution];

			[[executor.activeCommands should] haveCountOf:0];
			[[theValue(executor.active) should] equal:theValue(NO)];
		});
	});

	context(@"with two cancellable commands", ^
	{
		__block id command1 = [[CancellableTestCommand alloc] init];
		__block id command2 = [[CancellableTestCommand alloc] init];

		it(@"should cancel commands", ^
		{
			id mockReceiver = [KWMock mock];
			[[mockReceiver shouldEventuallyBeforeTimingOutAfter(1.0)] receive:@selector(testCall) withCount:2];

			executor.commandCallback = ^(id <MGCommand> command)
			{
				[mockReceiver performSelector:@selector(testCall)];
			};

			[executor executeCommand:command1 withUserInfo:nil];
			[executor executeCommand:command2 withUserInfo:nil];
			[executor cancelExecution];

			[[executor.activeCommands should] haveCountOf:0];
			[[theValue(executor.active) should] equal:theValue(NO)];
		});
	});

	context(@"with userInfo", ^
	{
		__block id command1 = [KWMock mockForProtocol:@protocol(MGCommand)];
		__block id command2 = [KWMock mockForProtocol:@protocol(MGCommand)];
		__block NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

		it(@"should execute commands", ^
		{
			[[command1 should] receive:@selector(execute)];
			[[command1 should] receive:@selector(setUserInfo:) withArguments:userInfo];
			[[command2 should] receive:@selector(execute)];
			[[command2 should] receive:@selector(setUserInfo:) withArguments:userInfo];

			[executor executeCommand:command1 withUserInfo:userInfo];
			[executor executeCommand:command2 withUserInfo:userInfo];
		});
	});
});

SPEC_END
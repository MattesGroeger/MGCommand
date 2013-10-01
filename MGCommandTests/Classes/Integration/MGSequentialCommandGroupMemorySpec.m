#import "Kiwi.h"
#import "MGCommandTestDelegate.h"

SPEC_BEGIN(MGSequentialCommandGroupMemorySpec)
		describe(@"MGSequentialCommandGroup", ^
		{
			context(@"with weak reference to the MGSequentialCommandGroup", ^
			{
				context(@"when execute on group is called", ^
				{
					context(@"without commands", ^
					{
						it(@"should dealloc after execution", ^
						{
							@autoreleasepool
							{
								MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

								[[delegate should] receive: @selector(deallocCalled)];

								[delegate executeEmptyMGSequentialCommandGroup];
							}
						});
					});

					context(@"with synchronous command", ^
					{
						it(@"should dealloc after execution", ^
						{
							@autoreleasepool
							{
								MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

								[[delegate should] receive: @selector(commandExecuted)];
								[[delegate should] receive: @selector(deallocCalled)];

								[delegate executeSynchronousMGSequentialCommandGroup];
							}
						});
					});

					context(@"with asynchronous command", ^
					{
						it(@"should dealloc after execution", ^
						{
							@autoreleasepool
							{
								MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

								[[delegate shouldEventually] receive: @selector(commandExecuted)];
								[[delegate shouldEventually] receive: @selector(deallocCalled)];

								[delegate executeAsynchronousMGSequentialCommandGroup];
							}
						});

						it(@"should call the completeHandler on completion", ^
						{
							MGCommandTestDelegate *delegate = [[MGCommandTestDelegate alloc] init];

							[[delegate shouldEventually] receive: @selector(asyncCommandsCompleted)];

							[delegate executeAsynchronousMGSequentialCommandGroup];
						});
					});
				});
			});
		});

		SPEC_END
#import "Kiwi.h"
#import "RetainGuardDelegate.h"

SPEC_BEGIN(MGCommandGroupRetainGuardSpec)
		describe(@"MGCommand_Retain", ^
		{
			context(@"when object is not retained", ^
			{
				it(@"should dealloc the instance", ^
				{
					RetainGuardDelegate *delegate = [[RetainGuardDelegate alloc] init];

					[[delegate should] receive: @selector(instanceReleased)];

					[delegate createObject];
				});
			});

			context(@"when object is retained", ^
			{
				it(@"should not dealloc the instance", ^
				{
					RetainGuardDelegate *delegate = [[RetainGuardDelegate alloc] init];

					[[delegate shouldNotEventually] receive: @selector(instanceReleased)];

					[delegate createObjectAndRetain];
				});

				context(@"when object is released immediatly", ^
				{
					it(@"should dealloc the instance", ^
					{
						RetainGuardDelegate *delegate = [[RetainGuardDelegate alloc] init];

						[[delegate should] receive: @selector(instanceReleased)];

						[delegate createObjectAndRetainAndRelease];
					});
				});
			});
		});

		SPEC_END
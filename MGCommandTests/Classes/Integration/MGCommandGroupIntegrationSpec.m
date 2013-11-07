#import "Kiwi.h"
#import "MGCommandGroup.h"

SPEC_BEGIN(MGCommandGroupIntegrationSpec)

describe(@"MGCommandGroup", ^
{
	context(@"with 1 MGAsyncCommand & 1 MGCommand", ^
	{
		context(@"when cancel is called", ^
		{
			it(@"should not throw an exception", ^
			{
				MGCommandGroup *group = [[MGCommandGroup alloc] init];
				[group addCommand: [KWMock nullMockForProtocol: @protocol(MGAsyncCommand)]];
				[group addCommand: [KWMock nullMockForProtocol: @protocol(MGCommand)]];
				[group execute];

				[group cancel];
			});
		});
	});
});

SPEC_END
#import "TestableMGSequentialCommandGroup.h"
#import "MGCommandTestDelegate.h"


@interface TestableMGSequentialCommandGroup ()
@property(nonatomic, weak) MGCommandTestDelegate *delegate;
@end

@implementation TestableMGSequentialCommandGroup
{

}
- (id)initWithDelegate: (MGCommandTestDelegate *)delegate
{
	if (self = [super init])
	{
		self.delegate = delegate;
	}

	return self;
}

- (void)dealloc
{
	[self.delegate deallocCalled];
}

@end
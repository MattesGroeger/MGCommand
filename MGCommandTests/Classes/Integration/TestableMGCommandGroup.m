#import "TestableMGCommandGroup.h"
#import "MGCommandTestDelegate.h"


@interface TestableMGCommandGroup ()

@property(nonatomic, weak) MGCommandTestDelegate *delegate;

@end

@implementation TestableMGCommandGroup

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
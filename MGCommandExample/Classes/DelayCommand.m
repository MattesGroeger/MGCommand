#import "DelayCommand.h"
#import "ViewController.h"
#import "Objection.h"


@implementation DelayCommand

- (id)initWithDelayInSeconds:(NSTimeInterval)aDelayInSeconds
{
	self = [super init];

	if (self)
	{
		_delayInSeconds = aDelayInSeconds;
	}

	return self;
}

- (void)execute
{
	ViewController *controller = [[JSObjection defaultInjector] getObject:[ViewController class]];

	[controller addOutput:[NSString stringWithFormat:@"DelayCommand (%d second)", (int) _delayInSeconds]];
	
	[self performSelector:@selector(finishAfterDelay)
			   withObject:nil
			   afterDelay:_delayInSeconds];
}

- (void)finishAfterDelay
{
	_callback();
}

@end
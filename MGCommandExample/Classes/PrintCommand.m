#import "PrintCommand.h"
#import "ViewController.h"
#import "Objection.h"


@implementation PrintCommand

- (id)initWithMessage:(NSString *)message
{
	self = [super init];

	if (self)
	{
		_message = message;
	}

	return self;
}

- (void)execute
{
	ViewController *controller = [[JSObjection defaultInjector] getObject:[ViewController class]];

	[controller addOutput:_message];
}

@end
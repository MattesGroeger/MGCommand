#import "BlockCommand.h"


@implementation BlockCommand

+ (id)create:(CommandBlock)commandComplete
{
	return [[BlockCommand alloc] initWithBlock:commandComplete];
}

- (id)initWithBlock:(CommandBlock)block
{
	self = [super init];

	if (self)
	{
		_commandBlock = block;
	}

	return self;
}

- (void)execute
{
	_commandBlock(_callback);
}

@end
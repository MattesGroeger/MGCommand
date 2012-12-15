#import <Foundation/Foundation.h>
#import "MGCommandGroup.h"


@interface MGSequentialCommandGroup : MGCommandGroup
{
@private
	NSUInteger _commandIndex;
}

@end
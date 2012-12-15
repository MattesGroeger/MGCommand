#import <Foundation/Foundation.h>
#import "MGCommand.h"


@interface PrintCommand : NSObject <MGCommand>
{
	NSString *_message;
}

- (id)initWithMessage:(NSString *)message;

@end
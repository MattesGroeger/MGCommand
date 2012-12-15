#import <Foundation/Foundation.h>
#import "MGAsyncCommand.h"


@interface MGCommandGroup : NSObject <MGAsyncCommand>
{
@private
	NSMutableArray *_commands;
}

@property (nonatomic, strong) CommandCallback callback;
@property (nonatomic, readonly) NSArray *commands;

- (void)addCommand:(id <MGCommand>)command;

- (NSUInteger)count;

@end
#import <Foundation/Foundation.h>
#import "MGAsyncCommand.h"

typedef void (^CommandBlock)(CommandCallback);

@interface BlockCommand : NSObject <MGAsyncCommand>
{
@private
	CommandBlock _commandBlock;
}

@property (nonatomic, strong) CommandCallback callback;

+ (id)create:(CommandBlock)commandComplete;

- (id)initWithBlock:(CommandBlock)block;

@end
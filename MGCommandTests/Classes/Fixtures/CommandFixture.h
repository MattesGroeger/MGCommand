#import <Foundation/Foundation.h>
#import "MGAsyncCommand.h"

#ifndef COMMAND_COUNT_VAR
#define COMMAND_COUNT_VAR
NSUInteger COMMAND_CALL_COUNT;
#endif

@interface AsyncTestCommand : NSObject <MGAsyncCommand>

@property (nonatomic, strong) CommandCallback callback;
@property (nonatomic) NSUInteger callCount;

@end

@interface TestCommand : NSObject <MGCommand>

@property (nonatomic) NSUInteger callCount;

@end

@interface AsyncDirectFinishTestCommand : NSObject <MGAsyncCommand>

@property (nonatomic, strong) CommandCallback callback;
@property (nonatomic) NSUInteger callCount;

@end
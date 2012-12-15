#import "MGCommand.h"

typedef void (^CommandCallback)(void);

@protocol MGAsyncCommand <MGCommand>

@property (nonatomic, strong) CommandCallback callback;

@end